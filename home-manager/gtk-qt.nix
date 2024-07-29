# Theme for graphical apps
{ machine, lib, pkgs, ... }:
let
  hasSeat = machine.seat != null;
  catppuccinFlavor = "macchiato";
  catppuccinAccent = "blue";
in
{
  home.packages = with pkgs; lib.mkIf hasSeat [
    papirus-folders
  ];

  # Mouse cursor
  catppuccin.pointerCursor = {
    enable = true;
    accent = catppuccinAccent;
    flavor = catppuccinFlavor;
  };

  # GTK Setup
  gtk = lib.mkIf hasSeat {
    enable = true;

    catppuccin = {
      #enable = true; # No need to set this anymore
      accent = catppuccinAccent;
      flavor = catppuccinFlavor;

      icon = {
        enable = true;
        accent = catppuccinAccent;
        flavor = catppuccinFlavor;
      };
    };

    gtk3 = {
      bookmarks = [
        "file:///"
        "file:///tmp"
        "file:///home/h/Downloads"
        "file:///home/h/drive/Docs"
        "file:///home/h/drive/Fotos"
        "file:///home/h/projects"
      ];
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };

  dconf.settings = lib.mkIf hasSeat {
    "org/gtk/settings/file-chooser" = {
      sort-directories-first = true;
    };
  };

  # Qt setup
  qt = lib.mkIf hasSeat {
    enable = true;

    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";

      catppuccin = {
        enable = true;
        apply = true;
        accent = catppuccinAccent;
        flavor = catppuccinFlavor;
      };
    };
  };
  xdg.configFile = lib.mkIf hasSeat {
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
}
