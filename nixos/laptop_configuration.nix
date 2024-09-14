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
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_10.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
            url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${version}.tar.xz";
            sha256 = "e0d50d5b74f8599375660e79f187af7493864dba5ff6671b14983376a070b3d1";
      };
      version = "6.10.6";
      modDirVersion = "6.10.6";
      };
  });

  boot.kernelParams = ["module_blacklist=nouveau,amdgpu"];

  boot.kernelPatches = let 
      g14_patches = fetchGit {
        url = "https://gitlab.com/dragonn/linux-g14";
        ref = "6.10";
        rev = "2318a770f912f115745b74e65fa7f504e5f593d1";
      };
      # Specifically for the g14 patches:
       graysky_2_path = fetchGit {
        url = "https://github.com/graysky2/kernel_compiler_patch";
        rev = "2c3e729bc302e8d2f825df359aa4a33d367f7f48";
       };
      cachyos_kernelPatches = fetchGit {
        url = "https://github.com/cachyos/kernel-patches";
        rev = "ccfdcab127bdde5d60ceafea075f55a12e4f4fdb";
      };
    in
    map (patch: { inherit patch; }) [
      #"sys-kernel_arch-sources-g14_files-0004-more-uarches-for-kernel-6.8-rc4+.patch"::"https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/master/more-uarches-for-kernel-6.8-rc4%2B.patch"
      # CHECK: maybe we have to replace 4%2B for +
      # "${graysky_2_path}/more-uarches-for-kernel-6.8-rc4+.patch" 6.10

      "${g14_patches}/0001-acpi-proc-idle-skip-dummy-wait.patch"

      "${g14_patches}/0003-platform-x86-asus-wmi-add-macros-and-expose-min-max-.patch"
      # "${g14_patches}/0042-v4-0-1-platform-x86-asus-wmi-add-support-for-vivobook-fan-profiles.patch"

      "${g14_patches}/0001-platform-x86-asus-wmi-add-debug-print-in-more-key-pl.patch"
      "${g14_patches}/0002-platform-x86-asus-wmi-don-t-fail-if-platform_profile.patch"
      "${g14_patches}/0003-asus-bios-refactor-existing-tunings-in-to-asus-bios-.patch"
      "${g14_patches}/0004-asus-bios-add-panel-hd-control.patch"
      "${g14_patches}/0005-asus-bios-add-dgpu-tgp-control.patch"
      "${g14_patches}/0006-asus-bios-add-apu-mem.patch"
      "${g14_patches}/0007-asus-bios-add-core-count-control.patch"

      "${g14_patches}/v2-0001-hid-asus-use-hid-for-brightness-control-on-keyboa.patch"

      "${g14_patches}/0027-mt76_-mt7921_-Disable-powersave-features-by-default.patch"

      "${g14_patches}/0032-Bluetooth-btusb-Add-a-new-PID-VID-0489-e0f6-for-MT7922.patch"
      "${g14_patches}/0035-Add_quirk_for_polling_the_KBD_port.patch"

      "${g14_patches}/0001-ACPI-resource-Skip-IRQ-override-on-ASUS-TUF-Gaming-A.patch"
      "${g14_patches}/0002-ACPI-resource-Skip-IRQ-override-on-ASUS-TUF-Gaming-A.patch"

      "${g14_patches}/0038-mediatek-pci-reset.patch"
      "${g14_patches}/0040-workaround_hardware_decoding_amdgpu.patch"

      "${g14_patches}/amd-tablet-sfh.patch"


      "${cachyos_kernelPatches}/6.10/sched/0001-sched-ext.patch"


      "${g14_patches}/sys-kernel_arch-sources-g14_files-0047-asus-nb-wmi-Add-tablet_mode_sw-lid-flip.patch"
      "${g14_patches}/sys-kernel_arch-sources-g14_files-0048-asus-nb-wmi-fix-tablet_mode_sw_int.patch"

      # ----- Old Stuff:

      # "${g14_patches}/sys-kernel_arch-sources-g14_files-0004-more-uarches-for-kernel-6.8-rc4+.patch "
      # "${g14_patches}/sys-kernel_arch-sources-g14_files-0005-lru-multi-generational.patch"

  ];

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
 #        CPU_MIN_PERF_ON_AC = 0;
 #        CPU_MAX_PERF_ON_AC = 80;
 #        CPU_MIN_PERF_ON_BAT = 0;
 #        CPU_MAX_PERF_ON_BAT = 20;
	#
 #       #Optional helps save long term battery health
 #       START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
 #       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
	#
 #      };
	# };

  # services.displayManager.sddm = {
  #   enable = true;
  #   wayland.enable = true;
  # };
  # programs.hyprland = {
  #   enable = true;
  #   xwayland.enable = true;
  #   #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  #   #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  # };

  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;


  programs.thunar.enable = true;

  # programs.waybar = {
  #   enable = true;
  # };

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


  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {

    modesetting.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = false;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      # version = "550.107.02";
      # sha256_64bit = "sha256-+XwcpN8wYCjYjHrtYx+oBhtVxXxMI02FO1ddjM5sAWg=";
      # sha256_aarch64 = "sha256-mVEeFWHOFyhl3TGx1xy5EhnIS/nRMooQ3+LdyGe69TQ=";
      # openSha256 = "sha256-Po+pASZdBaNDeu5h8sgYgP9YyFAm9ywf/8iyyAaLm+w=";
      # settingsSha256 = "sha256-WFZhQZB6zL9d5MUChl2kCKQ1q9SgD0JlP4CMXEwp2jE=";
      # persistencedSha256 = "sha256-Vz33gNYapQ4++hMqH3zBB4MyjxLxwasvLzUJsCcyY4k=";
      version = "560.31.02";
      sha256_64bit = "sha256-0cwgejoFsefl2M6jdWZC+CKc58CqOXDjSi4saVPNKY0=";
      sha256_aarch64 = "sha256-m7da+/Uc2+BOYj6mGON75h03hKlIWItHORc5+UvXBQc=";
      openSha256 = "sha256-X5UzbIkILvo0QZlsTl9PisosgPj/XRmuuMH+cDohdZQ=";
      settingsSha256 = "sha256-A3SzGAW4vR2uxT1Cv+Pn+Sbm9lLF5a/DGzlnPhxVvmE=";
      persistencedSha256 = "sha256-BDtdpH5f9/PutG3Pv9G4ekqHafPm3xgDYdTcQumyMtg=";

    };

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      nvidiaBusId = "PCI:64:00:0";
      amdgpuBusId = "PCI:65:00:0";
    };
  };
  hardware.opengl = {
    enable = true;
    package = pkgs.mesa.drivers;
    # enable32bit = true;
    # package = unstablePkgs.mesa.drivers;
    # driSupport = true;
    # driSupport32Bit = true;
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
    tlp
    lazygit
    dunst
    psmisc
    blueman
    bluez
    neofetch
    pavucontrol
    qalculate-gtk
    pciutils

    # Management Stuff
    lshw

    # pkgs.linuxPackages_6_10.asus-wmi-sensors
    neovim

    #Fonts
    jetbrains-mono
    noto-fonts-cjk-serif

    # For linux
  ];


  # For Docker
  virtualisation.docker.enable = true;
  users.users.ottersome.extraGroups = [ "docker" ];


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
