{
  config,
  pkgs,
  lib,
  ...
}: let
in {
  home = {
    stateVersion = "25.05";
    homeDirectory = "/Users/user";
  };
  home.packages = with pkgs; [
    vale
    obsidian
    nixd
    tokei
    hoppscotch
    iterm2
    wordnet
    fd
  ];

  home.shellAliases = {
    gherkin-lint = "npx gherkin-lint";
  };

  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    tmux = {
      enable = true;
      baseIndex = 1;
      plugins = with pkgs; [
        tmuxPlugins.resurrect
        tmuxPlugins.catppuccin
        tmuxPlugins.yank
        tmuxPlugins.vim-tmux-navigator
      ];
      extraConfig = ''

        unbind C-b
        set -g prefix C-Space
        bind C-Space send-prefix

        # Vim style pane selection
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        set-option -sa terminal-overrides ",xterm*:Tc"
        set -g mouse on
        set-window-option -g pane-base-index 1
        set-option -g renumber-windows off

        # set vi-mode
        set-window-option -g mode-keys vi
        # keybindings
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        # Use Lavender for inactive windows
        set -g window-status-format "#[fg=#b4befe]#I:#W#[default]"

        # Use Mauve for the active window
        set -g window-status-current-format "#[fg=#cba6f7,bold]#I:#W#[default]"
      '';
    };
  };
}
