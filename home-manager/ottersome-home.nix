# This is your home-manger configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  poetryPkgs,
  ...
}: 
let
  inherit (builtins) concatStringsSep;

  inherit (lib) fileContents;

  # Lets get the notion pkgs
  # TODO: Make it more platform agnostic

in
 {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # ./zsh.nix
    ../modules/nvim.nix
  ];

  programs.zsh = let 
    extraConfigBeforeCompInit = fileContents ./ottersome-home-configs/zsh/.zshrc_beforeCompInit + ''
      export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
    '';
    extraConfigAfterCompInit = fileContents ./ottersome-home-configs/zsh/.zshrc_afterCompInit;
  in {
    enable = true;
    # enableCompletion = true;
    enableCompletion = true; # for zsh-completions
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        # "zsh-syntax-highlighting"
        # "zsh-completions" # Comes automatic with nixos it seems
        # "zsh-autosuggestions"
        "ssh-agent"
        "poetry"
        "git"

      ];
    };
    # Pull info from ./ottersome-home.nix/zsh/.zshrc
    initExtraBeforeCompInit = extraConfigBeforeCompInit;
    initExtra = extraConfigAfterCompInit;
  };


  home = {
    username = "ottersome";
    homeDirectory = "/home/ottersome";
    # Simply stated packages
    packages = with pkgs; [
      # System
      (rofi-wayland.override {
        plugins = [ rofi-file-browser rofi-emoji];
      })
      firefox
      pywal
      onedriver
      bluetuith
      obs-studio
      wl-clipboard
      xdg-utils
      upower
      swww
      eww
      hyprpaper
      # Command LIne Utilities
      bat
      yazi
      alsa-utils
      lazygit
      kitty
      manix
      shell-gpt
      lsof # For reading ports
      jq # For reading json
      yq # For reading yaml
      ffmpeg
      swappy
      git-lfs
      cliphist
      tldr
      csvlens
      scrcpy # Controlling android remotely
      ttgo # Oh yeah 
      gh
      git-filter-repo
      unzip
      tree
      rclone
      tokei
      ranger


      ### For ZSH
      fzf
      zoxide
      pinentry
      eza
      zsh-autocomplete
      kdenlive
      zathura

      # UI
      feh
      dolphin
      obsidian
      spotify
      youtube-music
      discord
      slack
      vlc
      mpv
      sioyek
      tigervnc
      hyprshot
      flameshot
      telegram-desktop
      # papirus-icon-theme # Not working so fark with gtk 
      # For thunar thumbnailing
      xfce.tumbler 
      ffmpegthumbnailer
      lxappearance
      # appimageTools
      wdisplays
      inkscape
      # inkscape-with-extensions.override {
      #   inkscapeExtensions = [
      #     inkscape-extensions.textext
      #   ];
      # }
      
      # Random Falkes
      inputs.zen-browser.packages."${system}".default
      texlive.combined.scheme-full
      # inputs.notion-app.packages."${system}".notionAppElectron # TODO: FINISH THIS

      filezilla

      # TUI
      nvtopPackages.full

      # gcloud
      google-cloud-sdk
      redshift

      # Neovim: Not very comfortable with this , but it works
      # Ideally we create an environment for neovim with its own packages
      # unstablePkgs.python3
      # unstablePkgs.gnupg
      # unstablePkgs.gcc
      # unstablePkgs.nodejs
      # unstablePkgs.neovim
    ];
  };


  # For theming GTK 3.0
  gtk = {
    enable = true;
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "lavender";
      };
    };
    cursorTheme = {
      name = "Catppuccin-Mocha-Light-Cursors";
      package = pkgs.catppuccin-cursors.mochaLight;
    };
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };


  # Add stuff for your user as you see fit:
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    # Just leave it all here 
    # extraConfig = fileContents ./ottersome-home-configs/git/.gitconfig_global;
  };

  


  #wayland.windowManager.hyprland = {
  #  enable = true;
  #};
  # UI Configs
  # home.file."/home/ottersome/.config/hypr/"= {
  #   source = ./ottersome-home-configs/hypr;
  #   recursive = false;
  # };
  home.activation.copyHyprConfigs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${config.home.homeDirectory}/.config/hypr
    cp -r /etc/nixos/home-manager/ottersome-home-configs/hypr/* ${config.home.homeDirectory}/.config/hypr/
  '';
  home.file."/home/ottersome/.config/waypaper/"= {
    source = ./ottersome-home-configs/waypaper;
    recursive = false;
  };
  home.file."/home/ottersome/.config/git/.gitconfig_global" = {
    source = ./ottersome-home-configs/git/.gitconfig_global;
    recursive = false;
  };
  #home.file."/home/ottersome/.config/waybar/"= {
  #  source = ./ottersome-home-configs/waybar;
  #  recursive = false;
  #};


  # home.file.".config/hyprpaper" = {
  #   source = ./ottersome-home-configs/hyp;
  #   recursive = false;
  # };

  home.activation.installTPM = lib.hm.dag.entryAfter ["writeBoundary" "installPackages" "git"] ''
    export PATH="${lib.makeBinPath (with pkgs; [ git ])}:$PATH"
    TPM_DIR="${config.home.homeDirectory}/.tmux/plugins/tpm"
    TPM_REPO="https://github.com/tmux-plugins/tpm"

    if [ ! -d "$TPM_DIR" ]; then
        git clone "$TPM_REPO" "$TPM_DIR"
        echo 'REMEMBER: YOU HAVE TO Press <C-I>' to install tpm plugins.
    fi
  '';

  # xdg.configFile."nvim" = {
  #   # Got to use mkOUtofStoreSymLink otherwise backups will not allow us to write
  #   source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/home-manager/ottersome-home-configs/nvim;
  # };
  home.activation.copyNvimConfigs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${config.home.homeDirectory}/.config/nvim
    cp -r /etc/nixos/home-manager/ottersome-home-configs/nvim/* ${config.home.homeDirectory}/.config/nvim/
  '';
  home.activation.copyTmuxConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${config.home.homeDirectory}/.config/tmux
    cp -r /etc/nixos/home-manager/ottersome-home-configs/tmux/* ${config.home.homeDirectory}/.config/tmux/
  '';
  home.activation.copyWaybarConfigs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${config.home.homeDirectory}/.config/waybar
    cp -r /etc/nixos/home-manager/ottersome-home-configs/waybar/* ${config.home.homeDirectory}/.config/waybar/
  '';
  # Kitty Stuff
  home.activation.kittyConfigs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${config.home.homeDirectory}/.config/kitty
    cp -r /etc/nixos/home-manager/ottersome-home-configs/kitty/* ${config.home.homeDirectory}/.config/kitty/
  '';
  home.activation.sioyek = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${config.home.homeDirectory}/.config/sioyek
    cp -r /etc/nixos/home-manager/ottersome-home-configs/sioyek/* ${config.home.homeDirectory}/.config/sioyek/
  '';

  ########################################
  ## All ways of doing this
  ########################################
  # 1:
  # xdg.configFile."eww" = {
  #   # Got to use mkOUtofStoreSymLink otherwise backups will not allow us to write
  #   source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/home-manager/ottersome-home-configs/eww;
  # };
  # 2:
  # home.file.".config/kitty" = {
  #   source = ./ottersome-home-configs/kitty;
  #   recursive = true;
  # };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.sessionPath = [ "/home/ottersome/scripts" ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05"; # Did you read the comment?
  #xsession.windowManager.i3 = {
  #      enable = true;
  #      package = pkgs.i3-gaps;
  #      extraConfig = "";
  #};
}
