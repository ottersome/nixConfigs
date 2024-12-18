{
  description = "Lab Config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05"; # 24.05
    # home-manager.url = "github:nix-community/home-manager/release-23.11";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # pypoetry 
    poetryPkgs.url = "github:nix-community/poetry2nix";

    # My Notion 
    notion-app.url = "path:/etc/nixos/pkgs/notion-app";

    # Zen Browser
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    auto-cpufreq = {
       url = "github:AdnanHodzic/auto-cpufreq";
    };

    # TTGO: 
    ttgo = {
      url = "github:ottersome/ttgo?rev=825cd7fd5d79331e0d2f7f71cce2f34283a9dc3f";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    poetryPkgs,
    home-manager,
    ...
  } @ inputs: 
  let
    inherit (self) outputs;
    passing_down = {
      host_name = "trashcan";
    };
    system = "x86_64-linux";
    unstablePkgs = import nixpkgs-unstable {
    	inherit system;
      config.allowUnfree = true;
    };
    inherit (nixpkgs) lib; #TOREM:
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree =true;
        overlays = [
          (import ./overlays/neovim10.nix)
          (import ./overlays/rofi-wayland.nix)
        ];
      
    };
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      "berry" = nixpkgs.lib.nixosSystem rec{
        system = "aarch64-linux";
        specialArgs = {inherit pkgs inputs passing_down;};
        # > Our main nixos configuration file <
        modules = [
            {
              boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
              boot.loader.grub.enable = false;
              boot.loader.generic-extlinux-compatible.enable = true;
            }
            ./modules/users/personal.nix
            ./nixos/configuration.nix
            # inputs.home-manager.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ottersome = import ./home-manager/ottersome-home.nix;
              # home-manager.extraSpecialArgs = specialArgs;
            }
          ];
      };
      "lab716a" = nixpkgs.lib.nixosSystem rec{
        system = "x86_64-linux";
        specialArgs = {inherit pkgs inputs passing_down;};
        # > Our main nixos configuration file <
        modules = [
            ./modules/users/lab.nix
            ./nixos/configuration.nix
          ];
      };
      "mobile" = nixpkgs.lib.nixosSystem rec{
        system = "x86_64-linux";
        specialArgs = {inherit inputs unstablePkgs passing_down pkgs;};
        # > Our main nixos configuration file <
        modules = [
            ./modules/users/personal.nix
            ./nixos/laptop_configuration.nix
            # inputs.auto-cpufreq.nixosModules.default
          ];
      };
    };
    homeConfigurations = {
      # FIXME replace with your username@hostname
      "ottersome@mobile" = let 
            specialPkgs = pkgs // {
              ttgo = inputs.ttgo.packages.${system}.ttgo;
            };
          in home-manager.lib.homeManagerConfiguration {
          # Add the TTGO package to the pkgs list
        pkgs =  specialPkgs;
        extraSpecialArgs = {
            pkgs = specialPkgs;
            inherit inputs  outputs unstablePkgs poetryPkgs;
          };
        # > Our main home-manager configuration file <
        modules = [./home-manager/ottersome-home.nix];
      };
      "racc@lab716a" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./home-manager/racc-home.nix];
      };
      "nura@lab716a" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./home-manager/lab716a-home.nix.nix];
      };
    };
  };
}
