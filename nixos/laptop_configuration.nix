# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  passing_down,
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

  #nixpkgs = {
  #  # You can add overlays here
  #  overlays = [
  #    # If you want to use overlays exported from other flakes:
  #    # neovim-nightly-overlay.overlays.default

  #    # Or define it inline, for example:
  #    # (final: prev: {
  #    #   hi = final.hello.overrideAttrs (oldAttrs: {
  #    #     patches = [ ./change-hello-to-hi.patch ];
  #    #   });
  #    # })
  #  ];
  #  # Configure your nixpkgs instance
  #  config = {
  #    # Disable if you don't want unfree packages
  #    allowUnfree = true;
  #  };
  #};

  # So that we cant some linking happening



  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    nodejs
    # ...
  ];

  # For linking
  programs.zsh = {
    enable = true;
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
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["module_blacklist=nouveau"];

  networking.hostName = "${passing_down.host_name}";

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
  # services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  # services.xserver = {
  #   layout = "us";
  #   xkbVariant = "";
  # 
  #services.supergfxd.enable = true;

  services.asusd = {
  	enable = true;
	enableUserService = true;
  };

  services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

       #Optional helps save long term battery health
       START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

      };
	};

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };
  programs.thunar.enable = true;

  programs.waybar = {
    enable = true;
  };

  security.polkit.enable = true;
  # Policy Kit Agent will allow us to raise privileges for certain operations.
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };
  };


  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = true;
  #services.xserver = {
  #      enable = true;
  #      windowManager.i3.enable = true;
  #};
  #services.displayManager = {
  #	defaultSession = "none+i3";
  #};

  # Enable OpenGL
  #hardware.opengl = {
  #  enable = true;
  #};

  # Load nvidia driver for Xorg and Wayland
#  services.xserver.videoDrivers = ["nvidia"];
#
#  hardware.nvidia = {
#
#    # Modesetting is required.
#    modesetting.enable = true;
#
#    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
#    # Enable this if you have graphical corruption issues or application crashes after waking
#    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
#    # of just the bare essentials.
#    powerManagement.enable = false;
#
#    # Fine-grained power management. Turns off GPU when not in use.
#    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
#    powerManagement.finegrained = false;
#
#    # Use the NVidia open source kernel module (not to be confused with the
#    # independent third-party "nouveau" open source driver).
#    # Support is limited to the Turing and later architectures. Full list of 
#    # supported GPUs is at: 
#    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
#    # Only available from driver 515.43.04+
#    # Currently alpha-quality/buggy, so false is currently the recommended setting.
#    open = false;
#
#    # Enable the Nvidia settings menu,
#	# accessible via `nvidia-settings`.
#    nvidiaSettings = true;
#
#    # Optionally, you may need to select the appropriate driver version for your specific GPU.
#    package = config.boot.kernelPackages.nvidiaPackages.stable;
#  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

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
    tmux
    rsync
    btop
    home-manager
    brightnessctl
    #pactl
    #wpctl
    wget
    playerctl
    #linux-g14 
    asusctl
    supergfxctl
    tlp
    lazygit
    dunst
    psmisc
    blueman
    bluez

  ];



  #services.tailscale = {
  #  enable = true;
  #  useRoutingFeatures = lib.mkDefault "client";
  #  extraUpFlags = ["--login-server https://tailscale.m7.rs"];
  #};
  #networking.firewall.allowedUDPPorts = [41641]; # Facilitate firewall punching

  #environment.persistence = {
  #  "/persist".directories = ["/var/lib/tailscale"];
  #};

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "unstable";
}
