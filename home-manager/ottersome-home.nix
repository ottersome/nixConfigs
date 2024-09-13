# This is your home-manager configuration file
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

        # {
        #   name="fzf-tab";
        #   src=pkgs.fetchFromGithub {
        #     owner = "Aloxaf";
        #     repo = "fzf-tab";
        #   };
        # }
        # UNCOMMENT: If not using nix


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
      wofi
      firefox
      pywal
      onedriver
      bluetuith
      obs-studio
      upower
      swww
      eww
      hyprpaper
      unstablePkgs.davinci-resolve
      # Command LIne Utilities
      bat
      yazi
      lazygit
      kitty
      manix
      shell-gpt
      lsof # For reading ports
      jq # For reading json
      yq # For reading yaml
      ffmpeg

      ### For ZSH
      fzf
      zoxide
      pinentry
      eza
      zsh-autocomplete

      # UI
      feh
      dolphin
      obsidian
      spotify
      discord
      slack
      vlc
      sioyek
      tigervnc
      hyprshot
      telegram-desktop
      # papirus-icon-theme # Not working so fark with gtk 
      # For thunar thumbnailing
      xfce.tumbler 
      ffmpegthumbnailer
      lxappearance

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
      name = "Breeze-Dark";
      package = pkgs.libsForQt5.breeze-gtk;
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
    extraConfig = fileContents ./ottersome-home-configs/git/.gitconfig_global;
  };


  #wayland.windowManager.hyprland = {
  #  enable = true;
  #};
  # UI Configs
  home.file."/home/ottersome/.config/hypr/"= {
    source = ./ottersome-home-configs/hypr;
    recursive = false;
  };
  home.file."/home/ottersome/.config/waypaper/"= {
    source = ./ottersome-home-configs/waypaper;
    recursive = false;
  };
  #home.file."/home/ottersome/.config/waybar/"= {
  #  source = ./ottersome-home-configs/waybar;
  #  recursive = false;
  #};

  # Tmux Stuff
  home.file.".config/tmux/tmux.conf" = {
    source = ./ottersome-home-configs/tmux/tmux.conf;
    recursive = false;
  };
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

  xdg.configFile."nvim" = {
    # Got to use mkOUtofStoreSymLink otherwise backups will not allow us to write
    source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/home-manager/ottersome-home-configs/nvim;
  };
  xdg.configFile."waybar" = {
    # Got to use mkOUtofStoreSymLink otherwise backups will not allow us to write
    source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/home-manager/ottersome-home-configs/waybar;
  };
  xdg.configFile."eww" = {
    # Got to use mkOUtofStoreSymLink otherwise backups will not allow us to write
    source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/home-manager/ottersome-home-configs/eww;
  };

  # Kitty Stuff
  home.file.".config/kitty" = {
    source = ./ottersome-home-configs/kitty;
    recursive = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05"; # Did you read the comment?
  #xsession.windowManager.i3 = {
  #      enable = true;
  #      package = pkgs.i3-gaps;
  #      extraConfig = "";
  #};
}
