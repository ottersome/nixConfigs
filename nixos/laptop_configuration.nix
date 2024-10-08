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
    ../modules/CHINESE.nix
];

  # Specialisations
  specialisation = {
    plasma.configuration = {
      services.xserver.enable = true;
      services.displayManager.sddm.enable = true;
      services.displayManager.sddm.wayland.enable = true;
      services.desktopManager.plasma6 = {
        enable = true;
      };
    };
    hyprland.configuration = {
      programs.waybar = {
        enable = true;
      };
      services.power-profiles-daemon.enable = true;
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        # systemd.enable = true;
        package = inputs.hyprland.packages."${unstablePkgs.stdenv.hostPlatform.system}".hyprland;
        # package = inputs.hyprland.packages.${unstablePkgs.stdenv.hostPlatform.system}.hyprland;
        # package = inputs.hyprland.packages.${unstablePkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =  inputs.hyprland.packages.${unstablePkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };
    };
  };

  # TODO: Find a less harsh way of not using nvidia to drive plasma
  # --- Start: For completely disabling nvidia ---
  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
      '';
      services.udev.extraRules = ''
    # Remove NVIDIA USB xHCI Host Controller devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA USB Type-C UCSI devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA Audio devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA VGA/3D controller devices
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
      boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];


  # For pre-built CUDA packages
  nix.settings = {
    substituters = [
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
    experimental-features = "nix-command flakes";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    nodejs
    gcc
    # ...
  ];

  # Apparently cannot use in home-manager
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "DroidSansMono" ]; })
    noto-fonts-cjk-serif
  ];

  # For linking
  programs.zsh = {
    enable = true;
  };

  # Virtualbox
   virtualisation.virtualbox.host.enable = true;
   users.extraGroups.vboxusers.members = [ "ottersome" ];
   virtualisation.virtualbox.host.enableExtensionPack = true;

  # For NTFS Systems
  boot.supportedFilesystems = [ "ntfs" ];

  
  # --- end: For completely disabling nvidia ---

  # For dGPU + iGPY management. Hopefully lower power consumption
  # boot.extraModulePackages = [ pkgs.bbswitch ];
  # services.bumblebee.enable = true;
  # services.bumblebee.offload = false;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ../modules/linux-g14.nix {});

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

   networking.firewall.allowedTCPPorts = [ 8384 22000 ];
   networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  services.syncthing = {
    enable = true;
    user = "ottersome";
    dataDir = "/home/ottersome/synced";
     overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    settings = {
      # devices = {
      #   "device1" = { id = "DEVICE-ID-GOES-HERE"; };
      #   "device2" = { id = "DEVICE-ID-GOES-HERE"; };
      # };
      # folders = {
      #   "Documents" = {         # Name of folder in Syncthing, also the folder ID
      #     path = "/home/myusername/Documents";    # Which folder to add to Syncthing
      #     devices = [ "device1" "device2" ];      # Which devices to share the folder with
      #   };
      #   "Example" = {
      #     path = "/home/myusername/Example";
      #     devices = [ "device1" ];
      #     ignorePerms = false;  # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
      #  };
      };
  };

  services.asusd = {
  	enable = true;
    # enableUserService = true;
    package= unstablePkgs.asusctl;
  };

# Comment out to let gnome take care of it.

 #  services.tlp = {
 #      enable = true;
 #      settings = {
 #        CPU_SCALING_GOVERNOR_ON_AC = "performance";
 #        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
	#
 #        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
 #        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
	#
 #        RUNTIME_PM_ON_AC="auto";
 #        RUNTIME_PM_ON_BAT="auto";
	#
 #        PLATFORM_PROFILE_ON_AC="performance";
 #        PLATFORM_PROFILE_ON_BAT="low-power";
	#
 #        CPU_MIN_PERF_ON_AC = 0;
 #        CPU_MAX_PERF_ON_AC = 40;
 #        CPU_MIN_PERF_ON_BAT = 0;
 #        CPU_MAX_PERF_ON_BAT = 20;
	#
 #       #Optional helps save long term battery health
 #       START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
 #       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
	#
 #      };
	# };

  services.auto-cpufreq = {
    enable = true;
  };
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
   };
  powerManagement.powertop.enable = true;

  # For android mirroring:
  programs.adb.enable=true;


  # # For some Reason GNoem is not working for Nvidia + iGPU
  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;



  programs.thunar.enable = true;

  # For Steam
  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    # localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
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

  services.xserver.videoDrivers = ["amdgpu" "nvidia"];
  hardware.nvidia = {

    modesetting.enable = true;
    # powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "550.107.02";
      sha256_64bit = "sha256-+XwcpN8wYCjYjHrtYx+oBhtVxXxMI02FO1ddjM5sAWg=";
      sha256_aarch64 = "sha256-mVEeFWHOFyhl3TGx1xy5EhnIS/nRMooQ3+LdyGe69TQ=";
      openSha256 = "sha256-Po+pASZdBaNDeu5h8sgYgP9YyFAm9ywf/8iyyAaLm+w=";
      settingsSha256 = "sha256-WFZhQZB6zL9d5MUChl2kCKQ1q9SgD0JlP4CMXEwp2jE=";
      persistencedSha256 = "sha256-Vz33gNYapQ4++hMqH3zBB4MyjxLxwasvLzUJsCcyY4k=";
      # version = "560.31.02";
      # sha256_64bit = "sha256-0cwgejoFsefl2M6jdWZC+CKc58CqOXDjSi4saVPNKY0=";
      # sha256_aarch64 = "sha256-m7da+/Uc2+BOYj6mGON75h03hKlIWItHORc5+UvXBQc=";
      # openSha256 = "sha256-X5UzbIkILvo0QZlsTl9PisosgPj/XRmuuMH+cDohdZQ=";
      # settingsSha256 = "sha256-A3SzGAW4vR2uxT1Cv+Pn+Sbm9lLF5a/DGzlnPhxVvmE=";
      # persistencedSha256 = "sha256-BDtdpH5f9/PutG3Pv9G4ekqHafPm3xgDYdTcQumyMtg=";

    };

    prime = {
      # sync.enable = true;
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # You must conver lshw ids from hex to decimal
      nvidiaBusId = "PCI:100:00:0";
      amdgpuBusId = "PCI:101:00:0";
    };
  };
  hardware.opengl = {
    enable = true;
    package = pkgs.mesa.drivers;
    #TODO:
    # enable32bit = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  
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
  users.defaultUserShell = pkgs.zsh;

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

  # For GPG Keys:
  services.pcscd.enable = true;
  programs.gnupg.agent = {
   enable = true;
    #pinentryFlavor = "curses";
   enableSSHSupport = true;
   settings={
      default-cache-ttl = 3600;
    };
  };

  # services.supergfxd.enable = true;

  environment.systemPackages = with pkgs; [
    usbutils
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
    supergfxctl
    lazygit
    dunst
    psmisc
    blueman
    bluez
    neofetch
    pavucontrol
    qalculate-gtk
    pciutils
    getent
    unstablePkgs.auto-cpufreq
    fuse2
    icu.dev
    appimage-run
    polkit_gnome

    # Management Stuff
    lshw

    # pkgs.linuxPackages_6_10.asus-wmi-sensors

    #Fonts
    jetbrains-mono
    noto-fonts-cjk-serif

    # For linux
  ];


  # For Docker
  virtualisation.docker.enable = true;
  users.users.ottersome.extraGroups = [ "docker" "adbusers"];


  #services.tailscale = {
  #  enable = true;
  #  useRoutingFeatures = lib.mkDefault "client";
  #  extraUpFlags = ["--login-server https://tailscale.m7.rs"];
  #};
  #networking.firewall.allowedUDPPorts = [41641]; # Facilitate firewall punching

  #environment.persistence = {
  #  "/persist".directories = ["/var/lib/tailscale"];
  #};
#
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";

  # For Printing
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
