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
    ];
  };

}
