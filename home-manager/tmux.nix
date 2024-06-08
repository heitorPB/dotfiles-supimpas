{ pkgs, ... }:
{
  # Write the Tmux configuration file directly. Not a big fan of having this global
  # TODO: use https://github.com/catppuccin ?

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = "set -g @catppuccin_flavour 'macchiato' # latte,frappe, macchiato or mocha";
      }
    ];
    extraConfig = ''
      # Normalize TERM variable
      set -g default-terminal "screen-256color"

      # Increase history
      set-option -g history-limit 10000

      # Full color range
      set-option -ga terminal-overrides ",*256col*:Tc,alacritty:Tc"

      # Rebind main key to C-a
      unbind C-b
      set -g prefix C-a
      bind b send-prefix
      bind C-b last-window

      # Force a reload of the config file with C-<prefix> r
      unbind r
      bind r source-file ~/.tmux.conf \; display-message "Config reloaded"

      # Enable clicking around
      set -g mouse on

      # Pane movement shortcuts - same as Vi
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind -r H resize-pane -L 10
      bind -r J resize-pane -D 10
      bind -r K resize-pane -U 10
      bind -r L resize-pane -R 10

      # Use 24 hour clock
      setw -g clock-mode-style 24

      # Quick pane cycling
      # TODO what is this for?
      unbind ^A
      bind ^A select-pane -t :.+

      # Renumber windows when one is closed
      set -g renumber-windows on

      # Make splits open in the current dir
      unbind %
      bind % split-window -h -c "#{pane_current_path}"
      unbind \"
      bind \" split-window -v -c "#{pane_current_path}"

      # Reduce escape-time to be uniform with neovim
      # cf. https://github.com/neovim/neovim/issues/2035
      set-option -sg escape-time 10

      # Set focus-events for better nvim-tmux integration
      set-option -g focus-events on
    '';

  };
}
