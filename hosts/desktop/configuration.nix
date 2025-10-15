# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/modulebundle.nix
    ];

  # Enable custom modules
  # dev.enable = true; (enabled by default)
  # productivity.enable = true; (enabled by default)

  # Bootloader
  boot.loader = {
    #systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      gfxmodeEfi = "2560x1440";
      theme = pkgs.catppuccin-grub;
    };
  };

  boot.initrd.luks.devices."luks-733f38a1-065f-4aa0-96b0-398b7e6447db".device = "/dev/disk/by-uuid/733f38a1-065f-4aa0-96b0-398b7e6447db";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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

  # Install firefox
  programs.firefox.enable = true;

  # Allow unfree packages (Nvidia drivers, Discord, etc...)
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl
    wget
    home-manager
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
    hyprshot # screenshot
    nwg-look # theme setter
    rose-pine-hyprcursor # cursor theme
    nautilus # file explorer
    gnome.gvfs # samba
    samba # samba
    cifs-utils # old samba
    papirus-icon-theme # icon theme for file explorer
    catppuccin
    catppuccin-gtk
    catppuccin-cursors
    catppuccin-papirus-folders
  ];

  # Configure Nvidia
  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    # Opengl
    graphics.enable = true;
  };

  hardware.nvidia = {
    # Modesetting is required.
    # Most wayland compositors need this anyway
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
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

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
