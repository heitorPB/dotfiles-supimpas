{...}: {
  programs.tmux = {
    enable = true;

    # Set ${TERM} variable
    terminal = "screen-256color";

    # VI or Emacs shortcuts
    keyMode = "vi";

    # Enable clicking around
    mouse = true;

    # Set focus-events for better nvim-tmux integration
    focusEvents = true;

    # Use 24 hour clock
    clock24 = true;

    # Reduce escape-time to be uniform with neovim
    # cf. https://github.com/neovim/neovim/issues/2035
    escapeTime = 10;

    # Increase history
    historyLimit = 10000;

    extraConfig = ''
      # Reduce interval that Tmux updates status line
      set -g status-interval 1

      # Full color range
      set-option -ga terminal-overrides ",*256col*:Tc,alacritty:Tc"

      # Rebind main key to C-a
      unbind C-b
      set -g prefix C-a
      bind b send-prefix
      bind C-b last-window

      # Pane movement shortcuts - same as Vi
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind -r H resize-pane -L 10
      bind -r J resize-pane -D 10
      bind -r K resize-pane -U 10
      bind -r L resize-pane -R 10

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
    '';
  };
}
