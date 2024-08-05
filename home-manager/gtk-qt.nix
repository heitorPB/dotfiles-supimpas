# Theme for graphical apps
{ machine, lib, pkgs, ... }:
let
  hasSeat = machine.seat != null;

  catppuccinAccent = "Blue";
  catppuccinFlavor = "Macchiato";

  catppuccinKvantum = pkgs.catppuccin-kvantum.override {
    accent = catppuccinAccent;
    variant = catppuccinFlavor;
  };

  qtctConf = {
    Appearance = {
      custom_palette = false;
      icon_theme = "Papirus-Dark";
      standard_dialogs = "default";
      style = "kvantum";
    };
  };
in
{
  home.packages = with pkgs; lib.mkIf hasSeat [
    papirus-folders # Icons
    #catppuccin-papirus-folders # Conflicts with above

    # Theme for Qt apps
    catppuccinKvantum

    # I don't know If I need these
    libsForQt5.qt5ct
    #kdePackages.qt6ct
  ];

  # Mouse cursor
  catppuccin.pointerCursor = {
    enable = true;
    accent = lib.toLower "Lavender";
    flavor = lib.toLower catppuccinFlavor;
  };
  home.pointerCursor.size = machine.seat.cursorSize;

  # GTK Setup
  gtk = lib.mkIf hasSeat {
    enable = true;

    catppuccin = {
      #enable = true; # No need to set this anymore
      accent = lib.toLower catppuccinAccent;
      flavor = lib.toLower catppuccinFlavor;

      icon = {
        enable = true;
        accent = lib.toLower catppuccinAccent;
        flavor = lib.toLower catppuccinFlavor;
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

    platformTheme.name = "qt5ct";
    #platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
  #xdg.configFile."qt5ct/qt5ct.conf".text = lib.generators.toINI { } qtctConf;
  #xdg.configFile."qt6ct/qt6ct.conf".text = lib.generators.toINI { } qtctConf;
  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Catppuccin-${catppuccinFlavor}-${catppuccinAccent}
    '';

    "Kvantum/Catppuccin-${catppuccinFlavor}-${catppuccinAccent}".source = "${catppuccinKvantum}/share/Kvantum/Catppuccin-${catppuccinFlavor}-${catppuccinAccent}";
  };
}
