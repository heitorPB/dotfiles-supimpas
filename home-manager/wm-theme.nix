# Theme for graphical apps
{ machine, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    (catppuccin-kvantum.override {
      accent = "Blue";
      variant = "Mocha";
    })
    libsForQt5.qtstyleplugin-kvantum
    papirus-folders
  ];

  # Cursor setup
  home.pointerCursor = {
    name = "Catppuccin-Mocha-Lavender-Cursors";
    package = pkgs.catppuccin-cursors.mochaLavender;
    gtk.enable = true;
    size = machine.seat.cursorSize;
  };

  # GTK Setup
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "blue";
      };
    };
    cursorTheme = {
      name = "Catppuccin-Mocha-Lavender-Cursors";
      package = pkgs.catppuccin-cursors.mochaLavender;
    };
    gtk3 = {
      bookmarks = [
        "file:///home/h/projects"
        "file:///home/h/drive/Fotos"
        "file:///tmp"
      ];
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };
  dconf.settings = {
    "org/gtk/settings/file-chooser" = {
      sort-directories-first = true;
    };

    # GTK4 Setup
    "org/gnome/desktop/interface" = {
      gtk-theme = "Catppuccin-Mocha-Standard-Blue-Dark";
      color-scheme = "prefer-dark";
    };
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
    General.theme = "Catppuccin-Mocha-Blue";
  };

  systemd.user.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };
}
