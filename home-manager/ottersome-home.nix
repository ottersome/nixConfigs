# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # ./zsh.nix
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
      # obsidian
    ];
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "ottersome";
    userEmail = "admin@huginns.io";
  };
  programs.zsh.enable = true;

  #wayland.windowManager.hyprland = {
  #  enable = true;
  #};
  home.file."/home/ottersome/.config/hypr/"= {
    source = ./ottersome-home-configs/hypr;
    recursive = false;
  };
  home.file."/home/ottersome/.config/waypaper/"= {
    source = ./ottersome-home-configs/waypaper;
    recursive = false;
  };
  home.file."/home/ottersome/.config/waybar/"= {
    source = ./ottersome-home-configs/waybar;
    recursive = false;
  };
  home.file.".config/nvim" = {
    source = ./ottersome-home-configs/nvim;
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