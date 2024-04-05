# Theme for graphical apps
{ machine, lib, pkgs, ... }:
let
  hasSeat = machine.seat != null;
in
{
  home.packages = with pkgs; lib.mkIf hasSeat [
    (catppuccin-kvantum.override {
      accent = "Blue";
      variant = "Mocha";
    })
    papirus-folders
  ];

  # Cursor setup
  home.pointerCursor = lib.mkIf hasSeat {
    name = "Catppuccin-Mocha-Lavender-Cursors";
    package = pkgs.catppuccin-cursors.mochaLavender;
    gtk.enable = true;
    size = machine.seat.cursorSize;
  };

  # GTK Setup
  gtk = lib.mkIf hasSeat {
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
        "file:///home/h/Downloads"
        "file:///home/h/drive/Docs"
        "file:///home/h/drive/Fotos"
        "file:///home/h/projects"
        "file:///"
        "file:///tmp"
      ];
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };
  dconf.settings = lib.mkIf hasSeat {
    "org/gtk/settings/file-chooser" = {
      sort-directories-first = true;
    };

    # GTK4 Setup
    "org/gnome/desktop/interface" = {
      gtk-theme = "Catppuccin-Mocha-Standard-Blue-Dark";
      color-scheme = "prefer-dark";
    };
  };

  xdg.configFile = lib.mkIf hasSeat {
    kvantum = {
      target = "Kvantum/kvantum.kvconfig";
      text = lib.generators.toINI { } {
        General.theme = "Catppuccin-Mocha-Blue";
      };
    };

    qt5ct = {
      target = "qt5ct/qt5ct.conf";
      text = lib.generators.toINI { } {
        Appearance = {
          icon_theme = "Papirus-Dark";
        };
      };
    };

    qt6ct = {
      target = "qt6ct/qt6ct.conf";
      text = lib.generators.toINI { } {
        Appearance = {
          icon_theme = "Papirus-Dark";
        };
      };
    };
  };

  qt = lib.mkIf hasSeat {
    enable = true;
    platformTheme = "qtct";
    style = {
      name = "kvantum";
    };
  };

  systemd.user.sessionVariables = lib.mkIf hasSeat {
    QT_STYLE_OVERRIDE = "kvantum";
  };
}
