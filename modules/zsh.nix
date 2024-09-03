# Inspired by: https://github.com/divnix/digga/tree/167c692f9be447571ba45a4701862864baed3518/profiles/develop/zsh
# Meh, no tliking it to be honest.  A bit too scatttered
{ lib, pkgs, config, ... }:
let
    dependencies = with pkgs; [
      bat
      bzip2
      exa
      gitAndTools.hub
      unrar
      unzip
      xz
      zsh-completions
    ];

    zplug_home = "${config.home.homeDirectory}/.zsh/zshplug";

    makePkgConfigPath = x: lib.makeSearchPathOutput "dev" "lib/pkgconfig" x;
    makeIncludePath = x: lib.makeSearchPathOutput "dev" "include" x;

    zsh-depends-library = pkgs.buildEnv {
      name = "zsh-depends-library";
      paths = map lib.getLib dependencies;
      extraPrefix = "/lib/zsh-depends";
      pathsToLink = [ "/lib" ];
      ignoreCollisions = true;
    };
    zsh-depends-include = pkgs.buildEnv {
      name = "zsh-depends-include";
      paths = lib.splitString ":" (makeIncludePath dependencies);
      extraPrefix = "/lib/zsh-depends/include";
      ignoreCollisions = true;
    };
    zsh-depends-pkgconfig = pkgs.buildEnv {
      name = "zsh-depends-pkgconfig";
      paths = lib.splitString ":" (lib.makePkgConfigPath lib.build-dependent-pkgs);
      extraPrefix = "/lib/zsh-depends/pkgconfig";
      ignoreCollisions = true;
    };
    buildEnv = [
      "CPATH=${config.home.profileDirectory}/lib/zsh-depends/include"
      "CPLUS_INCLUDE_PATH=${config.home.profileDirectory}/lib/zsh-depends/include/c++/v1"
      "LD_LIBRARY_PATH=${config.home.profileDirectory}/lib/zsh-depends/lib"
      "LIBRARY_PATH=${config.home.profileDirectory}/lib/zsh-depends/lib"
      "NIX_LD_LIBRARY_PATH=${config.home.profileDirectory}/lib/zsh-depends/lib"
      "PKG_CONFIG_PATH=${config.home.profileDirectory}/lib/zsh-depends/pkgconfig"
      "ZPLUG_HOME=${config.zplug_home}/repos/"
    ];
  };


in
{
  users.defaultUserShell = pkgs.zsh;

  environment = {
    sessionVariables =
      let fd = "${pkgs.fd}/bin/fd -H";
      in
      {
        BAT_PAGER = "bat";
        SKIM_ALT_C_COMMAND =
          let
            alt_c_cmd = pkgs.writeScriptBin "cdr-skim.zsh" ''
              #!${pkgs.zsh}/bin/zsh
              ${fileContents ./cdr-skim.zsh}
            '';
          in
          "${alt_c_cmd}/bin/cdr-skim.zsh";
        SKIM_DEFAULT_COMMAND = fd;
        SKIM_CTRL_T_COMMAND = fd;
      };

    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";

      df = "df -h";
      du = "du -h";

      ls = "exa";
      l = "ls -lhg --git";
      la = "l -a";
      t = "l -T";
      ta = "la -T";

      ps = "${pkgs.procs}/bin/procs";

      rz = "exec zsh";
    };

  programs.zsh = {
    enable = true;

    enableGlobalCompInit = false;

    histSize = 10000;
    home.packages = with pkgs; [
      patchelf
      zsh-depends-include
      zsh-depends-library
      zsh-depends-pkgconfig
    ];

    setOptions = [
      "extendedglob"
      "incappendhistory"
      "sharehistory"
      "histignoredups"
      "histfcntllock"
      "histreduceblanks"
      "histignorespace"
      "histallowclobber"
      "autocd"
      "cdablevars"
      "nomultios"
      "pushdignoredups"
      "autocontinue"
      "promptsubst"
    ];

    promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init zsh)"
    '';

    interactiveShellInit =
      let
        zshrc = fileContents ./zshrc;

        sources = with pkgs; [
          ./cdr.zsh
          "${skim}/share/skim/completion.zsh"
          "${oh-my-zsh}/share/oh-my-zsh/plugins/sudo/sudo.plugin.zsh"
          "${oh-my-zsh}/share/oh-my-zsh/plugins/extract/extract.plugin.zsh"
          "${zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
          "${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
          "${zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
        ];

        source = map (source: "source ${source}") sources;

        functions = pkgs.stdenv.mkDerivation {
          name = "zsh-functions";
          src = ./functions;

          ripgrep = "${pkgs.ripgrep}";
          man = "${pkgs.man}";
          exa = "${pkgs.exa}";

          installPhase =
            let basename = "\${file##*/}";
            in
            ''
              mkdir $out

              for file in $src/*; do
                substituteAll $file $out/${basename}
                chmod 755 $out/${basename}
              done
            '';
        };

        plugins = concatStringsSep "\n" ([
          "${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin"
        ] ++ source);

      in
      ''
        ${plugins}

        fpath+=( ${functions} )
        autoload -Uz ${functions}/*(:t)

        ${zshrc}

        eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
        eval $(${pkgs.gitAndTools.hub}/bin/hub alias -s)
        source ${pkgs.skim}/share/skim/key-bindings.zsh

        # needs to remain at bottom so as not to be overwritten
        bindkey jj vi-cmd-mode
      '';
  };
}
