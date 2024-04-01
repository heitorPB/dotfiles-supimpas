# Default apps per file type
{ machine, lib, pkgs, ... }:
let
  hasSeat = machine.seat != null;
in
{
  xdg = {
    mimeApps = lib.mkIf hasSeat {
      enable = true;
      associations = {
        removed = {
          "image/gif" = "google-chrome.desktop";
          "image/jpeg" = "google-chrome.desktop";
          "image/png" = "google-chrome.desktop";
          "image/webp" = "google-chrome.desktop";
        };
      };
      defaultApplications = {
        "application/pdf" = "firefox.desktop";

        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
      };
    };

    # Default directories. Most I don't use. LOL
    userDirs = {
      enable = true;
      # createDirectories = true; # conflicts with impermanence

      # Make sure we're using the english ones.
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      pictures = "$HOME/Pictures";
      publicShare = "$HOME/Public";
      templates = "$HOME/Templates";
      videos = "$HOME/Videos";
      music = "$HOME/Music";
    };

    configFile.pcmanfm = lib.mkIf hasSeat {
      target = "pcmanfm-qt/default/settings.conf";
      text = lib.generators.toINI { } {
        Behavior = {
          NoUsbTrash = true;
          SingleWindowMode = false;
        };
        Places = {
          HiddenPlaces = "@invalid, /home/h/Desktop, trash:///, zroot";
        };
        System = {
          Archiver = "xarchiver";
          Terminal = "alacritty";
          SuCommand = "${pkgs.lxqt.lxqt-sudo}/bin/lxqt-sudo %s";
        };
        Thumbnail = {
          ShowThumbnails = true;
        };
        Volume = {
          AutoRun = false;
          CloseOnUnmount = true;
          MountOnStartup = false;
          MountRemovable = false;
        };
      };
    };
  };
}
