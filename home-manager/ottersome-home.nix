# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: 
let 
  myNvim = import ../modules/mynvim.nix {inherit pkgs;};
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # ./zsh.nix
    ../modules/nvim.nix
  ];

  # nixpkgs = {
  #   # You can add overlays here
  #   overlays = [
  #     # If you want to use overlays exported from other flakes:
  #     # neovim-nightly-overlay.overlays.racc
  #
  #     # Or define it inline, for example:
  #     # (final: prev: {
  #     #   hi = final.hello.overrideAttrs (oldAttrs: {
  #     #     patches = [ ./change-hello-to-hi.patch ];
  #     #   });
  #     # })
  #   ];
  #   # Configure your nixpkgs instance
  #   config = {
  #     # Disable if you don't want unfree packages
  #     allowUnfree = true;
  #     # Workaround for https://github.com/nix-community/home-manager/issues/2942
  #     allowUnfreePredicate = _: true;
  #   };
  # };
  # programs.zsh.initExtra = ''
  #     export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
  #   '';

  home = {
    username = "ottersome";
    homeDirectory = "/home/ottersome";
    # Simply stated packages
    packages = with pkgs; [
      lazygit
      kitty
      wofi
      firefox
      pywal
      onedriver
      bluetuith
      upower
      swww
      hyprpaper
      # obsidian

      manix
      # Neovim: Not very comfortable with this , but it works
      # Ideally we create an environment for neovim with its own packages
      # unstablePkgs.python3
      # unstablePkgs.gnupg
      # unstablePkgs.gcc
      # unstablePkgs.nodejs
      # unstablePkgs.neovim
    ];
  };

  # Add stuff for your user as you see fit:
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "ottersome";
    userEmail = "admin@huginns.io";
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
