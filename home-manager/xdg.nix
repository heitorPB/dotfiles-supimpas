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
        # Find the default apps with `xdg-mime query default MIME_TYPE`
        # And/or look into /run/current-system/sw/share/applications/
        removed = {
          "application/pdf" = "google-chrome.desktop";

          "image/bmp" = "google-chrome.desktop;com.ultimaker.cura.desktop";
          "image/gif" = "google-chrome.desktop;com.ultimaker.cura.desktop";
          "image/jpeg" = "google-chrome.desktop;com.ultimaker.cura.desktop";
          "image/png" = "google-chrome.desktop;com.ultimaker.cura.desktop";
          "image/webp" = "google-chrome.desktop;com.ultimaker.cura.desktop";

          # .docx
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "calibre-ebook-edit.desktop;calibre-ebook-viewer.desktop;calibre-gui.desktop";
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

        "image/bmp" = "feh.desktop";
        "image/gif" = "feh.desktop";
        "image/jpeg" = "feh.desktop";
        "image/png" = "feh.desktop";
        "image/webp" = "feh.desktop";

        # .docx
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "writer.desktop";
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
        FolderView = {
          Mode = "detailed";
          BigIconSize = 64;
          SidePaneIconSize = 32;
          SmallIconSize = 32;
          ThumbnailIconSize = 128;
        };
        Places = {
          HiddenPlaces = "@invalid, /home/h/Desktop, trash:///, zroot";
        };
        System = {
          Archiver = "xarchiver";
          Terminal = "alacritty";
          SuCommand = "${pkgs.lxqt.lxqt-sudo}/bin/lxqt-sudo %s";
          FallbackIconThemeName = "Papirus-Dark";
        };
        Thumbnail = {
          ShowThumbnails = true;
        };
        Volume = {
          AutoRun = false;
          CloseOnUnmount = false; # Go to home folder instead of closing tab
          MountOnStartup = false;
          MountRemovable = false;
        };
      };
    };
  };
}
