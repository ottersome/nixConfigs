# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # FIXME: Add the rest of your current configuration
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lab716a";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Taipei";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    lab716a = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "itlablinux";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
    };
    racc = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "itlablinux";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
	"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCw0fgl5QxyFmqY1Hcg2RSCm7XLQlIQ5naFY9S1OAmOV8LnTpqjG0YLs8K8Z2bgioykH8EBj0rnyMPNj31XmXZB55ss810yOMH4M4tpKpPdyvxOIxh+IcLluj4uiq018Tzj5+zXXhDQlh4HQdxqQFCvX7n/2VPF8GpWOd74wxO0HKirBAakxH+wvVrns62XAJyKYkTSMYHg1h8UMrKf2SLO3lVdmTmLHGxpLu+sa9jJnP9bZhop049EmGye2lSvrfn+ZWKMBnbsN4byLhrXCeVIDJ/4TJuJWqZmnWWw6Nbz7y8KKm4FdkhmVY/cXiYf6+1XThWePQwxcrpwC1voosy7ZXfXldV1jwTpU5d/3t4sfJ6Wufi2gys7b9HDdAbGJU+sU4hmi99JPUp59S23/kyl7x4/utcksodXmR67OBYqUZakvT27FpI1xq6ITMH6NvyNb1zLSOlVIFlVIrZjbOkkcqg3WoAZwk6kN9mDhQrzjxvMreCesx3bXjbuI+WbnE6B/vaz62u/WYfygIRupRkiunpSRA3qzOjt+iBbGJYmXzr7v762pdleG6ALznpqE4S7SaZO7/y+KU5INBUiqeC6iYD+5HWmCM69YZnj7du+CUdyAjEFXbHFGiZ6SccNwLKPpSNfXyTHDRHnRS7A2Rcdfeo5V5eZhXXwF2L18KECKQ== luisgarcia26284@gmail.com
"
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel"];
    };
    root = {
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
	"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCw0fgl5QxyFmqY1Hcg2RSCm7XLQlIQ5naFY9S1OAmOV8LnTpqjG0YLs8K8Z2bgioykH8EBj0rnyMPNj31XmXZB55ss810yOMH4M4tpKpPdyvxOIxh+IcLluj4uiq018Tzj5+zXXhDQlh4HQdxqQFCvX7n/2VPF8GpWOd74wxO0HKirBAakxH+wvVrns62XAJyKYkTSMYHg1h8UMrKf2SLO3lVdmTmLHGxpLu+sa9jJnP9bZhop049EmGye2lSvrfn+ZWKMBnbsN4byLhrXCeVIDJ/4TJuJWqZmnWWw6Nbz7y8KKm4FdkhmVY/cXiYf6+1XThWePQwxcrpwC1voosy7ZXfXldV1jwTpU5d/3t4sfJ6Wufi2gys7b9HDdAbGJU+sU4hmi99JPUp59S23/kyl7x4/utcksodXmR67OBYqUZakvT27FpI1xq6ITMH6NvyNb1zLSOlVIFlVIrZjbOkkcqg3WoAZwk6kN9mDhQrzjxvMreCesx3bXjbuI+WbnE6B/vaz62u/WYfygIRupRkiunpSRA3qzOjt+iBbGJYmXzr7v762pdleG6ALznpqE4S7SaZO7/y+KU5INBUiqeC6iYD+5HWmCM69YZnj7du+CUdyAjEFXbHFGiZ6SccNwLKPpSNfXyTHDRHnRS7A2Rcdfeo5V5eZhXXwF2L18KECKQ== luisgarcia26284@gmail.com
"
      ];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "yes";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };
  environment.systemPackages = with pkgs; [
    git
    neovim
    tmux
    rsync
  ];

  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client";
    extraUpFlags = ["--login-server https://tailscale.m7.rs"];
  };
  networking.firewall.allowedUDPPorts = [41641]; # Facilitate firewall punching

  #environment.persistence = {
  #  "/persist".directories = ["/var/lib/tailscale"];
  #};

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
