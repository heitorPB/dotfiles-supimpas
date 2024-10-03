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
    amdGpuSensor = "amdgpu-pci-0700";
    nvidiaGpu = null;
    battery = "BAT0";
    cpuSensor = "k10temp-pci-00c3";
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
      cursorSize = 32;
    };
  };

  dellG3 = {
    hostname = "G3";
    location = geolocation.piracicaba;

    identityFile = "~/.ssh/id_ed25519.G3";
    gitKey = "heitorpbittencourt@gmail.com";
    gpgPinentryPackage = "qt";

    amdGpu = null;
    amdGpuSensor = null;
    nvidiaGpu = 0;
    battery = "BAT0";
    cpuSensor = "coretemp-isa-0000";
    mainNetworkInterface = "wlan0";
    nvmeSensors = [ "nvme-pci-3a00" ];

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
      cursorSize = 32;
    };
  };
}
