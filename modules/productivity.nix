{ config, pkgs, lib, ... }: {

  options = {
    productivity.enable = 
      lib.mkEnableOption "enables productivity module";
  };

  config = lib.mkIf config.productivity.enable {

    environment.systemPackages = with pkgs; [
      rnote
      obsidian
      syncthing
      anki-bin
      hugo
      ticker
      signal-desktop
      bc
      sdcv
      libreoffice-fresh
      voxtype # local voice-to-text
      wineWow64Packages.waylandFull
    ];

    # Create syncthing service that'll survive reboot
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = "bobby";
      dataDir = "/home/bobby";
    };

    # AirDrop alternative
    programs.localsend = {
      enable = true;
    };

  };

}
