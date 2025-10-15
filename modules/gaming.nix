{ config, pkgs, lib, ... }: {

  options = {
    gaming.enable = 
      lib.mkEnableOption "enables gaming module";
  };

  config = lib.mkIf config.gaming.enable {

    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;

    environment.systemPackages = with pkgs; [
      mangohud
      protonup
    ];

    programs.gamemode.enable = true;

    # Now you can include launch options in games:
    # gamemoderun %command%
    # mangohud %command%
    # gamescope %command%

    # proton GE installation path
    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = 
        "/home/bobby/.steam/root/compatibilitytools.d";
    }; # Then run the protonup command in the terminal

  };

}
