{ config, lib, pkgs, unstablePkgs, inputs, ... }:
# Courtery of: https://geanmar.com/posts/how-to-setup-nvim-on-nixos/
with lib;
let
  build-dependent-pkgs = with pkgs; [
      acl
      attr
      bzip2
      curl
      libsodium
      libssh
      libxml2
      openssl
      stdenv.cc.cc
      systemd
      util-linux
      xz
      zlib
      zstd
      glib
      gcc
      glibc
      libcxx
      poetry
  ];

  overlayed = import <nixpkgs> {
    system = "x86_64-linux";
    config.allowUnfree = true;
    overlays = [
      (import ../overlays/neovim10.nix)
    ];
  };
  makePkgConfigPath = x: makeSearchPathOutput "dev" "lib/pkgconfig" x;
  makeIncludePath = x: makeSearchPathOutput "dev" "include" x;

  nvim-depends-library = pkgs.buildEnv {
    name = "nvim-depends-library";
    paths = map lib.getLib build-dependent-pkgs;
    extraPrefix = "/lib/nvim-depends";
    pathsToLink = [ "/lib" ];
    ignoreCollisions = true;
  };
  nvim-depends-include = pkgs.buildEnv {
    name = "nvim-depends-include";
    paths = splitString ":" (makeIncludePath build-dependent-pkgs);
    extraPrefix = "/lib/nvim-depends/include";
    ignoreCollisions = true;
  };
  nvim-depends-pkgconfig = pkgs.buildEnv {
    name = "nvim-depends-pkgconfig";
    paths = splitString ":" (makePkgConfigPath build-dependent-pkgs);
    extraPrefix = "/lib/nvim-depends/pkgconfig";
    ignoreCollisions = true;
  };
  buildEnv = [
    "CPATH=${config.home.profileDirectory}/lib/nvim-depends/include"
    "CPLUS_INCLUDE_PATH=${config.home.profileDirectory}/lib/nvim-depends/include/c++/v1"
    "LD_LIBRARY_PATH=${config.home.profileDirectory}/lib/nvim-depends/lib"
    "LIBRARY_PATH=${config.home.profileDirectory}/lib/nvim-depends/lib"
    "NIX_LD_LIBRARY_PATH=${config.home.profileDirectory}/lib/nvim-depends/lib"
    "PKG_CONFIG_PATH=${config.home.profileDirectory}/lib/nvim-depends/pkgconfig"
  ];
in {
  home.packages = with pkgs; [
    patchelf
    nvim-depends-include
    nvim-depends-library
    nvim-depends-pkgconfig
    ripgrep
  ];
  home.extraOutputsToInstall = ["nvim-depends"];
  home.shellAliases.nvim = (concatStringsSep " " buildEnv)
    + " SQLITE_CLIB_PATH=${pkgs.sqlite.out}/lib/libsqlite3.so " + "nvim";

  #home.file.".config/nvim" = {
  #   source = ../home-manager/ottersome-home-configs/nvim;
  #   recursive = true;
  #};
  # xdg.configFile."nvim" = {
  #   # Got to use mkOUtofStoreSymLink otherwise backups will not allow us to write
  #   source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/home-manager/ottersome-home-configs/nvim;
  # };
  # home.activation.copyNvimConfigs = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   mkdir -p ${config.home.homeDirectory}/.config/nvim
  #   cp -r /etc/nixos/home-manager/ottersome-home-configs/nvim/* ${config.home.homeDirectory}/.config/nvim/
  # '';
  home.sessionVariables = {
    EDITOR = "nvim";
  };


  programs.neovim  = {
    package = overlayed.neovim-unwrapped;
    # package = overlayed.neovim-unwrapped;
	# package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    enable = true;

    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs;
      [
      ruff-lsp
      black
      pyright
      nil
      imagemagick
      rsync
      ];
    #   [
    #     doq
    #     sqlite
    #     cargo
    #     clang
    #     cmake
    #     gcc
    #     gnumake
    #     ninja
    #     pkg-config
    #     yarn
    #     gnupg
    #     unzip
    #     nil # For Nix Dev
    #   ];
    extraLuaPackages = ls: with ls; [ luarocks magick];
    #NOTE:(1): Install the `magick` lua rock so we can use 3rd/image.nvim
  };
}
