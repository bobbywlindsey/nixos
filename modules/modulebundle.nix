{ pkgs, lib, ... }: {

  imports = [
    ./dev.nix
    ./productivity.nix
  ];

  # Enable each module (can be overriden in configuration.nix files)
  dev.enable = true;
  productivity.enable = true;
}
