# nixos

It's a simple NixOS config.

### Install

Install the NixOS base:

1. `git clone https://github.com/bobbywlindsey/nixos.git && cd nixos/`
2. `sudo nixos-rebuild switch --flake .#laptop`

Then install dotfiles for hyprland, neovim, etc...:

`cd && git clone https://github.com/bobbywlindsey/dotfiles.git && cd dotfiles/nixos`

### Update

Change directory into where you cloned the NixOS config. Then:

`sudo nix flake update && sudo nixos-rebuild switch --flake .#laptop`

### Cleanup

1. `sudo nix-collect-garbage -d`
2. `sudo nixos-rebuild switch --flake .#laptop`
