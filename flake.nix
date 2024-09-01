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
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
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
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      "berry" = nixpkgs.lib.nixosSystem rec{
        system = "aarch64-linux";
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
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
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        specialArgs = {inherit pkgs inputs passing_down;};
        # > Our main nixos configuration file <
        modules = [
            ./modules/users/lab.nix
            ./nixos/configuration.nix
          ];
      };
      "mobile" = nixpkgs.lib.nixosSystem rec{
        system = "x86_64-linux";
        pkgs = import nixpkgs {
           inherit system;
           config.allowUnfree = true;
         };
        specialArgs = {inherit inputs unstablePkgs passing_down;};
        # > Our main nixos configuration file <
        modules = [
            ./modules/users/personal.nix
            ./nixos/laptop_configuration.nix
          ];
      };
    };
    homeConfigurations = {
      # FIXME replace with your username@hostname
      "ottersome@mobile" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system}; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs unstablePkgs;};
        # > Our main home-manager configuration file <
        modules = [./home-manager/ottersome-home.nix];
      };
      "racc@lab716a" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./home-manager/racc-home.nix];
      };
      "nura@lab716a" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./home-manager/lab716a-home.nix.nix];
      };
    };
  };
}
