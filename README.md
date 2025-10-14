# nixos

It's a simple NixOS config.

### Install

`sudo stow -t /etc/nixos/ .`

### Update

`sudo nix flake update && sudo nixos-rebuild --flake .#desktop`
