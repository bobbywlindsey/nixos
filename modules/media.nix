{ config, pkgs, lib, ... }: {

  options = {
    media.enable = 
      lib.mkEnableOption "enables media module";
  };

  config = lib.mkIf config.media.enable {

    environment.systemPackages = with pkgs; [
      vlc
      mpv # video player
      calibre
      (ffmpeg-full.override { withUnfree = true; })
      gimp-with-plugins
      inkscape-with-extensions
      darktable
      rawtherapee
      imagemagick
      yt-dlp
      obs-studio
      epy # terminal ebook reader
      picard # music metadata
      playerctl # control media player
      mpdris2 # MPRIS 2 support for mpd
      mpc # cli interface for MPD
      rmpc # terminal music player
      astroterm # celestial viewer
      swayimg # Wayland image viewer
      evince # pdf viewer
    ];
  };

}
