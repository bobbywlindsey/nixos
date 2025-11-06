# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/modulebundle.nix
    ];


  # Enable custom modules
  gaming.enable = lib.mkOverride 1000 false;

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-46a44d17-e59d-4729-885e-d804e6fd7ac3".device = "/dev/disk/by-uuid/46a44d17-e59d-4729-885e-d804e6fd7ac3";

  networking.hostName = "laptop"; # Define your hostname.
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone
  time.timeZone = "America/Denver";

  # Select internationalization properties
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

  # Display/login manager for Wayland
  services.displayManager.ly.enable = true;

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable sound with pipewire
  services.pulseaudio.enable = false;
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

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };
  services.blueman.enable = true;


  # Enable touchpad support (enabled default in most desktopManager)
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'
  users.users.bobby = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "bobby";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages (Nvidia drivers, Discord, etc...)
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl
    wget
    home-manager
    librewolf
    qutebrowser

    # Hyprland
    waybar # bar
    # Display work spaces correctly on Hyprland
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    )
    dunst # notification daemon
    libnotify # notification dependency for dunst
    swww # wallpaper
    rofi-wayland # app launcher
    hyprlock # lock screen
    hypridle # idle daemon
    hyprshot # screenshot
    brightnessctl # control screen brightness
    nwg-look # theme setter
    nautilus # file explorer
    gnome.gvfs # samba
    samba # samba
    cifs-utils # old samba
    papirus-icon-theme # icon theme for file explorer
    catppuccin
    catppuccin-gtk
    catppuccin-cursors.mochaDark
    catppuccin-papirus-folders
    pavucontrol # gtk volume control
    networkmanagerapplet # gnome applet to control NetworkManager
  ];

  # Configure Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    # If your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";

    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";

    MOZ_ENABLE_WAYLAND = "1";
  };

  # Handle desktop program interactions with each other (screensharing, file opening, etc...)
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Enable automount of drives (e.g. USB drive)
  services.udisks2.enable = true;

  # Samba client support for gtk file explorers
  services.gvfs.enable = true;

  # Enable network discovery in Nautilus
  services.avahi = {
    enable = true;
    nssmdns4= true;
  };

  # Enable keyring to connect to external servers
  services.gnome.gnome-keyring.enable = true;

  # Prevent overheating for intel CPUs
  services.thermald.enable = true;

  # Power management
  services.tlp = {
      enable = true;
      settings = {
        # See availble governor and energy policies:
        # tlp-stat -p
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 80;

       # Help save long-term battery health
       START_CHARGE_THRESH_BAT0 = 85; # 30 and below it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 90; # 90 and above it stops charging
      };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
