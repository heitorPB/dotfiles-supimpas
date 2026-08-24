# Configurations and options for all hosts
{
  pkgs,
  machine,
  lib,
  inputs,
  ...
}: {
  # Import nix.nix here to clean up flakes.nix
  imports = [../shared/nix.nix];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernel.sysctl = {
    "kernel.sysrq" = 1; # Enable ALL SysRq shortcuts
    #"vm.max_map_count" = 2147483642; # helps with Wine ESYNC/FSYNC
  };

  boot.zfs.forceImportRoot = false;

  networking.hostName = machine.hostname;

  # Use tmpfs for /tmp
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "100%";
  };

  # Remove unused storage stuff
  services.lvm.enable = false;
  boot.swraid.enable = false;

  # Allow all firmwares to be there
  hardware.enableAllFirmware = true;

  # Daemon to keep firmware up to date
  services.fwupd.enable = true;

  # "enp3s0" instead of "eth0".
  networking.usePredictableInterfaceNames = true;

  # Use Systemd for DNS resolution
  services.resolved = {
    enable = true;
    settings.Resolve.fallbackDns = [
      "1.1.1.1#cloudflare-dns.com"
      "9.9.9.9#dns.quad9.net"
      "8.8.8.8#dns.google"
      "2606:4700:4700::1111#cloudflare-dns.com"
      "2620:fe::9#dns.quad9.net"
      "2001:4860:4860::8888#dns.google"
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
    extraConfig = ''
      # Automatically remove stale sockets on connect
      StreamLocalBindUnlink yes

      # Send timeout message every 60 s to request answer from clients
      ClientAliveInterval 60
    '';
  };

  # Use Systemd timesyncd for NTP
  services.timesyncd.enable = true;

  # Set time zone
  time.timeZone = machine.location.timezone;

  # Internationalisation properties.
  i18n = {
    defaultLocale = "en_DK.UTF-8";
    supportedLocales = ["en_DK.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" "pt_BR.UTF-8/UTF-8"];
    extraLocaleSettings = {
      LC_MESSAGES = "en_DK.UTF-8";
      LC_CTYPE = "en_DK.UTF-8"; # "pt_BR.UTF8" borks xkbcommon
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
      LC_COLLATE = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
    };
  };

  # Fix wrong sudo password messages
  security.sudo = {
    package = pkgs.sudo.override {withInsults = true;};
    extraConfig = ''
      Defaults insults
    '';
  };
  security.polkit.enable = true;

  # Colored man pages
  environment.variables = {
    MANPAGER = "less -R --use-color -Dd+r -Du+b";
    MANROFFOPT = "-P -c";
  };

  environment.shellAliases = {
    # I am lazy
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    p = "cd ~/projects/";

    # Colors everywhere
    grep = "grep --color=auto";
    ip = "ip -color=auto";
    diff = "diff --color=auto";
    watch = "watch --color";

    # My own ls's
    #ls = "ls --color=auto"; # This is not needed, --color=tty is the default
    l = "ls -lahF";
    ls1 = "ls -1F";
  };

  # Packages for all machines
  environment.systemPackages = with pkgs; [
    bat # Fancier cat(1)
    btop # Fancier top(1)
    fd # Fancier find(1)
    file
    killall
    kmon # Kernel monitoring
    lm_sensors # Show my temperatures
    man-pages # More manuals
    pciutils # For lspci(8)
    pinentry-curses # Pinentry for gnupg
    rclone # Added ~/.config/rclone to impermanence
    ripgrep # Fancier grep(1)
    rsync
    smartmontools # For S.M.A.R.T. tooling
    tree # List directories in a nice looking tree structure
    unzip # To revert zip operations
    usbutils # For lsusb(8)
    wget
    wol # Wake On Lan client
    yazi # File browser TODO config
    zip # To zip or not to zip

    # Development and workflow
    claude-code # Added ~/.claude{,.json,.json.backup} to impermanence
    git
    gnumake # For make
    jq # JSON parser
    prek # Better pre-commit
    tmux # Moar terminals
    yq # Like jq, but for YAML

    # Bash Development
    bash-language-server
    shellcheck
    shfmt

    # Learning
    exercism # ~/.config/exercism/ added to impermanence

    # Direnv and a handy extension
    direnv
    nix-direnv

    # THE editor and its plugins
    neovim # Also added .config/nvim and .local/share/nvim to impermanence
    tree-sitter
    fzf

    # Python and its Development packages
    (python3.withPackages (p:
      with p; [
        debugpy
        ipython
      ]))
    pyright # Python LSP
    ruff # Python Linter / LSP
    uv # Python package manager

    # Rust Development
    #cargo
    #rustc
    #rustfmt
    #rust-analyzer # LSP
    #clippy # Ultimate linter?
    #gcc # Needed to get a linker for rustc. Could be clang instead

    alejandra # Nix formatter
    nil # Nix LSP

    # Golang and its language-server
    # Note: added ~/go to impermanence
    go
    gopls # LSP
    delve # Debugger
    golangci-lint
    govulncheck # Vulnerability scanner
    gcc # Needed for C/Go. Also needed for tree-sitter and rustc (as linker)

    # Terraform and its language-server
    #terraform
    #terraform-ls
    # Ansible
    #ansible

    # AWS
    awscli2 # TODO: move this only to machines that need
    ssm-session-manager-plugin # Amazon SSM manager plugin
    #eksctl # AWS EKS

    # MS Azure TODO: move this only to machines that need
    (azure-cli.withExtensions [
      azure-cli-extensions.ssh
    ])

    # Google Cloud Platform - GCP
    google-cloud-sdk # `gcloud` CLI
  ];

  # Neovim everywhere
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };
  environment.variables = {
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim"; # For sudo -e
  };

  # Enable nh as an ultimate Nix CLI
  programs.nh = {
    enable = true;
    clean.enable = false; # conflicts with nix.gc.automatic
    clean.extraArgs = "--keep 5 --keep-since 4d";
  };

  # Fake /lib64/ld-linux-x868-64.so.x so we can run pre-compiled binaries, e.g.
  # dowloaded via `pip install bla`, numpy, etc. Not all problems are solved by
  # it, but helpful. Also useful to `export LD_LIBRARY_PATH=${NIX_LD_LIBRARY_PATH}`
  # for cases where some lib failed to load. Note: use with care this `export`,
  # setting it globally unleashes havoc: LD_LIBRARY_PATH affects all programs,
  # overwriting it can inject wrong libraries in correctly built Nix
  # applications.
  programs.nix-ld.enable = true;

  # Update man pages cache to make apropos work
  documentation.man.cache.enable = true;

  # My user in all hosts
  users.users.h = {
    uid = 1000;
    isNormalUser = true;
    # TODO: systemd-journal is some kind of bug: I shouldn't need to be in it (see man journalctl)
    extraGroups = ["wheel" "podman" "systemd-journal" "networkmanager" "docker"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxMuFUrQujzveHDbM8etG1A2rQhA8i2KwM0j2BiFx0K h@alien"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDmUxVAr/I2+Fdw2oxpKhzlt+tSIojo+yAbzzmACbKRh h@L14"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHOFTWgQBX/7Sc9L5cKI6bW9nIjChqYayeINKVEn9+dU h@G3"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILj25ERftYj4WBuNeZT843ekPma+pc1feNc9y8VM9DfL h@nas"
    ];
  };

  # home-manager settings
  home-manager.useGlobalPkgs = true;

  # Configure GnuPG agent
  programs.gnupg.agent = {
    enable = true;
    enableExtraSocket = true;
    enableSSHSupport = true; # Make GPG through SSH work
    pinentryPackage = lib.mkIf (machine.gpgPinentryPackage == "curses") (
      pkgs.pinentry-curses
    );

    settings = {
      default-cache-ttl = 21600;
      default-cache-ttl-ssh = 21600;
      max-cache-ttl = 21600;
      max-cache-ttl-ssh = 21600;
    };
  };
  # Required to get pinentry working
  # https://discourse.nixos.org/t/cant-get-gnupg-to-work-no-pinentry/15373/10
  services.pcscd.enable = true;
}
