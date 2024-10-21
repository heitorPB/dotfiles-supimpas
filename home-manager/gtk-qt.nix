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

  qtThemeName = "Catppuccin-${catppuccinFlavor}-${catppuccinAccent}";
in
{
  home.packages = with pkgs; lib.mkIf hasSeat [
    papirus-folders # Icons
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
    style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/${qtThemeName}".source = "${catppuccinKvantum}/share/Kvantum/${qtThemeName}";
    "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
      General.theme = qtThemeName;
    };
  };
}
