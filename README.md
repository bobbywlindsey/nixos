# nixos

It's a simple NixOS config.

### Install

Install the NixOS base:

1. `git clone https://github.com/bobbywlindsey/nixos.git && cd nixos/`
2. `sudo nixos-rebuild --flake .#desktop`

Then install dotfiles for hyprland, neovim, etc...:

1. `cd && git clone https://github.com/bobbywlindsey/dotfiles.git && cd dotfiles/nixos`
2. `stow -t ~/ hypr`
3. `stow -t ~/ nvim`
4. `stow -t ~/ alacritty`
5. `stow -t ~/ waybar`
6. `stow -t ~/ rofi`

### Update

Change directory into where you cloned the NixOS config. Then:

`sudo nix flake update && sudo nixos-rebuild --flake .#desktop`
