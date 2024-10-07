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
in
{
  home.packages = with pkgs; lib.mkIf hasSeat [
    papirus-folders # Icons
    #catppuccin-papirus-folders # Conflicts with above

    # Theme for Qt apps - do I need this?
    catppuccinKvantum
  ];

  # Mouse cursor - Only non-blue Catppuccin
  home.pointerCursor = lib.mkIf hasSeat {
    name = "catppuccin-${lib.toLower catppuccinFlavor}-lavender-cursors";
    package = pkgs.catppuccin-cursors.${lib.toLower catppuccinFlavor + "Lavender"};
    gtk.enable = true;
    size = machine.seat.cursorSize;
  };

  # GTK Setup
  gtk = lib.mkIf hasSeat {
    enable = true;

    theme = {
      name = "catppuccin-${lib.toLower catppuccinFlavor}-${lib.toLower catppuccinAccent}-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "${lib.toLower catppuccinAccent}" ];
        size = "standard";
        variant = "${lib.toLower catppuccinFlavor}";
      };
    };
    iconTheme = {
      name = "Papirus"; # WTF?
      #name = "cat-${lib.toLower catppuccinFlavor}-${lib.toLower catppuccinAccent}";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "${lib.toLower catppuccinFlavor}";
        accent = "${lib.toLower catppuccinAccent}";
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
        accent =lib.toLower catppuccinAccent;
        flavor =lib.toLower catppuccinFlavor;
      };
    };
  };
}
