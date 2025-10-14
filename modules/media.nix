{ config, pkgs, lib, ... }: {

  options = {
    media.enable = 
      lib.mkEnableOption "enables media module";
  };

  config = lib.mkIf config.media.enable {

    environment.systemPackages = with pkgs; [
      vlc
      calibre
      (ffmpeg-full.override { withUnfree = true; })
      gimp3-with-plugins
      inkscape-with-extensions
      davinci-resolve # free version
      imagemagick
      yt-dlp
    ];
  };

}
