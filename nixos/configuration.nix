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

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
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
    nura = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "itlablinux";
      isNormalUser = true;
      # shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
	"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDdKI0Y+LD6+K/VRSBE/8lNHI/8/hNywXIAQAbc9Z4kfYLKWGXF04N2/TI9KpWXuwGw7933U3BTjQDqbtBKPaO+koEWGIkrVLYWw2+UVHaF3c/NyIkMpXY9eqxQbUZ3HXv9IhVhkQXNeuYtKCoAYA2PWqV2Jja1YMLjaAZFU6OFuDXgj9qDgnceIdTG3haPChgV8sZdhuiZ/76n7OxBjqVPKAaTet2KOCxEDaAyQNSLenj4oi6IQ/xu/jUHfML0iiO5aQAsxDyzWnM/ayZFYJznvqXyLUD0Cr/NpD4Q2GrnJmvBzHKDk1859r4vxaRIHJW8R5SraMF09GB1vU4H4aRvv+o/15+sUydoVSan1uqNPtfXTxhOIrO8jIPYVIDLHyjlpxJmpndpRhgeFeql9Sg1hKe5TqXSmie5kcvVMKqlsTkEzlYLaephIBlSfIhOndw5zjGfyUvxcxHxIAFyzec0Gsvz4bTwRQzBFUKDjmy2NDsOO/WRXLo5M8T5I5cf3gGjGM9FSsKBmpFgY+keGZL04qcu/7fp8zN3hjolfaaBhGDi4SM4Y7ktFF3faamUCUeA8aK738Tj2YXVKmV8DnSyucij6omw/meluw9betST9DVlGWbnF5tb1tEqOaedmiI/mE9C9r5Aa3WY+5vuqyYBj+DfpAxeN0WRUBPuloDsiQ== nurassyl.askar@gmail.com
"
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
    };
    racc = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "itlablinux";
      isNormalUser = true;
      # shell = pkgs.zsh;
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
  system.stateVersion = "24.05";
}
