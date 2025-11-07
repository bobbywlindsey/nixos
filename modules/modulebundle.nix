{ pkgs, lib, ... }: {

  imports = [
    ./dev.nix
    ./productivity.nix
    ./media.nix
    ./video_editing.nix
    ./gaming.nix
    ./security.nix
  ];

  # Enable each module (can be overridden in configuration.nix files)
  dev.enable = true;
  productivity.enable = true;
  media.enable = true;
  video_editing.enable = true;
  gaming.enable = true;
  security.enable = true;
}
