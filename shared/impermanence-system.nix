# System wide Impermanence configuration
# NOTE: not in hosts/core.nix because I don't have impermanence on desk03 yet
{ chaotic, ... }:

{
  # ZFS-based impermanence
  chaotic.zfs-impermanence-on-shutdown = {
    enable = true;
    volume = "zroot/ROOT/empty";
    snapshot = "start";
  };

  # Persistent files
  environment.persistence."/var/persistent" = {
    hideMounts = true;
    directories = [
      # Critical directories to keep
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/etc/ssh"
      "/var/lib/bluetooth"
      "/var/lib/containers"
      "/var/lib/cups"
      { directory = "/var/lib/iwd"; mode = "u=rwx,g=,o="; }
      "/var/lib/systemd"
      "/var/lib/upower"

      # Not that important but good to keep
      # TODO: move this to another partition to simplify backup?
      "/var/cache"
      "/var/log"
      "/var/spool"
    ];
    files = [
      "/etc/machine-id"
    ];

    # Files and directories for root user
    users.root = {
      home = "/root";
      directories = [
        { directory = ".gnupg"; mode = "0700"; }
        { directory = ".ssh"; mode = "0700"; }
      ];
    };

    # Files and directories for my user
    users.h = {
      directories = [
        { directory = ".aws"; mode = "0700"; }
        { directory = ".gnupg"; mode = "0700"; }
        ".config/asciinema"
        ".config/btop"
        ".config/cura"
        ".config/darktable"
        ".config/keepassxc"
        ".config/klavaro"
        ".config/pasteur-chrome"
        ".config/qBittorrendarktablet"
        ".config/spotify"
        ".local/share/Anki2"
        ".local/share/containers"
        ".local/share/cura"
        ".local/share/direnv"
        ".local/share/klavaro"
        ".local/share/qBittorrent"
        ".local/share/Steam"
        ".local/share/TelegramDesktop"
        ".mozilla"
        ".ssh"
        "cloud"
        "drive"
        "projects"
        "Downloads"

        # Not that critical, but helpful to keep around.
        ".cache/anki"
        ".cache/darktable"
        ".cache/keepassxc"
        ".cache/mesa_shader_cache"
        ".cache/mozilla"
        ".cache/spotify"
      ];
      files = [
        ".bash_history"
      ];
    };
  };

  # Shadow can't be added to persistent
  # Hashes generated with mkpasswd
  users.users."root".hashedPassword = "$y$j9T$En/tncDLL/8mNvg4LTYB3.$NI9ucL2URMZxMIXK5IvQzBsvQVayjOmOUNCplOtxyT9"; # NixPass3wold!
  users.users."h".hashedPassword = "$y$j9T$x4IC.F3ZmiYzMDFfmxwYo0$NfThb527VpBcBylPEefO59NCoWlEkfwS1ga0FS5hITC";
}
