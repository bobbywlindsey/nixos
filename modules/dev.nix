{ config, pkgs, lib, ... }: {

  options = {
    dev.enable = 
      lib.mkEnableOption "enables dev module";
  };

  config = lib.mkIf config.dev.enable {

    environment.systemPackages = with pkgs; [
      neovim
      gcc
      ripgrep
      alacritty
      alacritty-theme
      tmux
      tmuxifier
      nerd-fonts.meslo-lg
      stow
      htop
      unrar
      tree
    ];

    # Configure fish shell
    programs.fish = {
      enable = true;

      shellAbbrs = {
        v = "nvim";
        dls = "cd ~/Downloads/";
        projects = "cd ~/GitProjects";
        dotfiles = "cd ~/GitProjects/dotfiles";
        clipboard="xclip -sel clip";
        clean_image="exiftool -all= ";
      };

      interactiveShellInit = ''
      	set -g -x PATH /usr/local/bin \
               ~/.tmuxifier/bin \
               ~/bin \
	$PATH

	function fish_greeting
          echo "Time to get shit done ᕦ(ò_óˇ)ᕤ"
	end
      '';
    };

    # Configure git
    programs.git = {
      enable = true;
      config = {
        user.name = "Bobby Lindsey";
        user.email = "contact@bobbywlindsey.com";
        core.editor = "nvim";
        push.default = "simple";
        alias = {
          co = "checkout";
          cm = "commit";
          st = "status";
          logp = "log -- pretty";
          logg = "log --all --decorate --oneline --graph";
        };
      };
    };

    # Configure tmux
    programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        catppuccin
      ];
      extraConfig = ''
	# Remap leader key from Ctrl+b to Ctrl+s
	set -g prefix C-s

	# Resize panes with mouse
	set -g mouse on

	# Sync tmux color with neovim color
	set-option -ga terminal-overrides ",xterm-256color:Tc"

	# Vim nagivation of panes
	bind-key h select-pane -L
	bind-key j select-pane -D
	bind-key k select-pane -U
	bind-key l select-pane -R

	set-option -g status-position top

	# List of plugins
	set -g @plugin 'tmux-plugins/tpm'
	set -g @plugin 'christoomey/vim-tmux-navigator'
	set -g @plugin 'catppuccin/tmux#v2.1.3'

	# Configure the catppuccin plugin
	set -g @catppuccin_window_status_style "rounded"

	# Load catppuccin
	run ~/.tmux/plugins/tmux/catppuccin.tmux

	set -g status-right-length 100
	set -g status-left-length 100
	set -g status-left ""
	set -g status-right "#{E:@catppuccin_status_application}"
	set -ag status-right "#{E:@catppuccin_status_session}"

	# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
	run '~/.tmux/plugins/tpm/tpm'
      '';
    };

  };
}
