{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "notion-app-electron";
  version = "3.14.0";
  srcs = {
    notionDmg = pkgs.fetchurl {
      url = "https://desktop-release.notion-static.com/Notion-${version}.dmg";
      sha256 = "5d7b762f522754b74c78bd0f0ebf292e6750224ee7bc4a3837156bdb5722ab11";
    };
    betterSqlite = pkgs.fetchurl {
      url = "https://github.com/WiseLibs/better-sqlite3/releases/download/v11.2.1/better-sqlite3-v11.2.1-electron-v125-linux-x64.tar.gz";
      sha256 = "f07a731e5da5337516bacd8f1d12cabb70a2e62f1caa4a43212b26fa7546cbe2";
    };
    bufferUtil = pkgs.fetchurl {
      url = "https://github.com/websockets/bufferutil/releases/download/v4.0.8/v4.0.8-linux-x64.tar";
      sha256 = "eac6fabcfa38e21c33763cb0e5efc1aa30c333cf9cc39f680fb8d12c88fefc93";
    };
    notionAppScript = ./notion-app;
    notionDesktopFile = ./notion.desktop;
    notionIcon = ./notion.png;
  };

  nativeBuildInputs = [ pkgs.p7zip pkgs.asar ];

  buildInputs = [
    pkgs.bash
    pkgs.gcc
    pkgs.glibc
    pkgs.hicolor-icon-theme
    pkgs.electron_31
  ];

  installPhase = ''
    # Extract the Notion .dmg
    7z x ${srcs.notionDmg} "Notion/Notion.app/Contents/Resources/app.asar" -y -bse0 -bso0 || true

    # Extract the app.asar file
    asar e Notion/Notion.app/Contents/Resources/app.asar asar_patched

    # Replace better-sqlite3 and bufferutil files
    tar xzf ${srcs.betterSqlite} -C asar_patched/node_modules/better-sqlite3/build/Release/
    tar xvf ${srcs.bufferUtil} -C asar_patched/node_modules/bufferutil/build/Release/

    # Copy the icon and make patches
    cp ${srcs.notionIcon} asar_patched/.webpack/main/trayIcon.png

    # Apply patches
    sed -i 's/if("darwin"===process.platform){const e=s.systemPreferences?.getUserDefault(E,"boolean"),t=_.Store.getState().app.preferences?.isAutoUpdaterDisabled;return Boolean(e||t)}return!1/return!0/g' asar_patched/.webpack/main/index.js
    sed -i 's/Menu.setApplicationMenu(p(e))/Menu.setApplicationMenu(null)/g' asar_patched/.webpack/main/index.js
    sed -i 's|this\.tray\.on("click",(()=>{this\.onClick()}))|this.tray.setContextMenu(this.trayMenu),this.tray.on("click",(()=>{this.onClick()}))|g' asar_patched/.webpack/main/index.js
    sed -i 's|getIcon(){[^}]*}|getIcon(){return s.default.join(__dirname, "trayIcon.png");}|g' asar_patched/.webpack/main/index.js
    sed -i 's/a\.app\.on("open-url",_.handleOpenUrl)):"win32"===process\.platform/a\.app\.on("open-url",_.handleOpenUrl)):"linux"===process\.platform/g' asar_patched/.webpack/main/index.js

    # Repack the modified asar file
    asar p asar_patched app.asar --unpack *.node

    # Install the application
    install -Dm644 app.asar $out/lib/notion-app/app.asar
    install -Dm755 ${srcs.notionAppScript} $out/bin/notion-app
    install -Dm644 ${srcs.notionDesktopFile} $out/share/applications/notion.desktop
    install -Dm644 ${srcs.notionIcon} $out/share/icons/hicolor/256x256/apps/notion.png
  '';

  meta = with pkgs.lib; {
    description = "Your connected workspace for wiki, docs & projects";
    homepage = "https://www.notion.so/desktop";
    license = licenses.unfree;
    maintainers = with maintainers; [ yourGitHubUsername ];
    platforms = platforms.linux;
  };
}
