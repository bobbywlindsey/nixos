{ config, pkgs, lib, ... }: {

  options = {
    video_editing.enable = 
      lib.mkEnableOption "enables video editing module";
  };

  config = lib.mkIf config.video_editing.enable {

    environment.systemPackages = with pkgs; [
      davinci-resolve # free version
    ];

  };

}
