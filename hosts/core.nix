# Configurations and options for all hosts
{ inputs, pkgs, machine, ... }:
{
  # Import nix.nix here to clean up flakes.nix
  imports = [ ../shared/nix.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernel.sysctl = {
    "kernel.sysrq" = 1; # Enable ALL SysRq shortcuts
    #"vm.max_map_count" = 2147483642; # helps with Wine ESYNC/FSYNC
  };

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

  # Daemon to keep firmware up to date # TODO: remove from headless?
  services.fwupd.enable = true;

  # "enp3s0" instead of "eth0".
  networking.usePredictableInterfaceNames = true;

  # Use Systemd for DNS resolution
  services.resolved = {
    enable = true;
    fallbackDns = [
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
  environment.variables = {
    CURRENT_CITY = machine.location.city + ", " + machine.location.country;
    CURRENT_GEO = machine.location.latitude + ":" + machine.location.longitude;
  };

  # Internationalisation properties.
  i18n = {
    defaultLocale = "en_DK.UTF-8";
    supportedLocales = [ "en_DK.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" "pt_BR.UTF-8/UTF-8" ];
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

  # Override some packages' settings/sources
  # Downgrade gnupg to 2.2.27. TODO: remove later
  nixpkgs.overlays = [ (final: prev: { gnupg = inputs.nixpkgs-gnupg.legacyPackages.${final.system}.gnupg; }) ];

  # Fix wrong sudo password messages
  security.sudo = {
    package = pkgs.sudo.override { withInsults = true; };
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
    ls1 = "ls -1";
  };

  # Packages for all machines
  environment.systemPackages = with pkgs; [
    btop # Fancier top(1)
    dysk # Fancier df(1)
    fd # Fancier find(1)
    file
    killall
    kmon # Kernel monitoring
    lm_sensors # Show my temperatures
    man-pages # More manuals
    pciutils # For lspci(8)
    pinentry-curses # Pinentry for gnupg
    ripgrep # Fancier grep(1)
    rsync
    tree # List directories in a nice looking tree structure
    usbutils # For lsusb(8)
    wget
    wireguard-tools

    # Development and workflow
    git
    gnumake # For make
    jq # JSON parser
    tmux

    # Direnv and a handy extension
    direnv
    nix-direnv

    # THE editor and its plugins
    neovim
    fzf
    silver-searcher
    rnix-lsp # Nix LSP

    # Python and its Development packages
    (python3.withPackages (p: with p; [
      ipython
      #python-lsp-server # Use it in a per-project dev shell
      #python-lsp-ruff
    ]))

    # Golang and its language-server
    #go
    #gopls

    # Terraform and its language-server
    #terraform
    #terraform-ls
    # Ansible
    #ansible

    # AWS
    awscli2
    #eksctl # AWS EKS

    # Clouds should fly
    #flyctl

    # MS Azure
    azure-cli

    # Kubernetes clients
    #kubectl
    #k9s # TUI for k8s
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

  # Update man pages cache to make apropos work
  documentation.man.generateCaches = true;

  # My user in all hosts
  users.users.h = {
    uid = 1000;
    isNormalUser = true;
    # systemd-journal is some kind of bug: i shouldn't need to be in it (see man journalctl)
    extraGroups = [ "wheel" "podman" "systemd-journal" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxMuFUrQujzveHDbM8etG1A2rQhA8i2KwM0j2BiFx0K h@alien"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDmUxVAr/I2+Fdw2oxpKhzlt+tSIojo+yAbzzmACbKRh h@L14"
    ];
  };

  # home-manager settings
  home-manager.useGlobalPkgs = true;

  # Configure GnuPG agent
  programs.gnupg.agent = {
    enable = true;
    enableExtraSocket = true;
    enableSSHSupport = true; # Make GPG through SSH work
    pinentryFlavor = machine.gpgPinentry; # Options: curses, gnome3, gtk2, qt
  };
}
