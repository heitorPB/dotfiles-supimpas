# Single source of thruth.
_:

# TODO: turn this into a function for correctness
rec {
  geolocation = import ./geolocation.nix;

  desktop = {
    hostname = "desk03";
    location = geolocation.piracicaba;

    identityFile = "~/.ssh/id_ed25519.desk03";
    gitKey = "heitorpbittencourt@gmail.com";
    gpgPinentryPackage = "curses";

    seat = null;
  };

  thinkpadL14 = {
    hostname = "L14";
    location = geolocation.piracicaba;

    identityFile = "~/.ssh/id_ed25519.L14";
    gitKey = "heitorpbittencourt@gmail.com";
    gpgPinentryPackage = "qt";

    amdGpu = "card1";
    battery = "BAT0";
    cpuSensor = "k10temp-pci-00c3";
    gpuSensor = "amdgpu-pci-0700";
    mainNetworkInterface = "wlan0";
    nvmeSensors = [ "nvme-pci-0100" ];

    # Graphical thingies
    seat = {
      # Monitor
      displayId = "LG Display 0x40A9 Unknown";
      displayWidth = 1920;
      displayHeight = 1080;
      displayRefresh = 60; # In Hz

      notificationX = "right";
      notificationY = "top";

      # Mouse pointer/cursor size
      cursorSize = 16;
    };
  };

  dellG3 = {
    hostname = "G3";
    location = geolocation.piracicaba;

    identityFile = "~/.ssh/id_ed25519.G3";
    gitKey = "heitorpbittencourt@gmail.com";
    gpgPinentryPackage = "qt";

    amdGpu = "card1"; # TODO: check this
    nvidiaGpu = "card1"; # TODO: add this
    battery = "BAT0"; # TODO: check this
    cpuSensor = "k10temp-pci-00c3"; # TODO: check this
    gpuSensor = "amdgpu-pci-0700"; # TODO: check this
    mainNetworkInterface = "wlan0";
    nvmeSensors = [ "nvme-pci-0100" ]; # TODO: check this

    # Graphical thingies
    seat = {
      # Monitor
      displayId = "Najing CEC Panda FPD Technology CO. ltd 0x0054 Unknown";
      displayWidth = 1920;
      displayHeight = 1080;
      displayRefresh = 120; # In Hz

      notificationX = "right";
      notificationY = "top";

      # Mouse pointer/cursor size
      cursorSize = 16;
    };
  };
}
