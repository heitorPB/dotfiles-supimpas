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
    gpgPinentry = "curses";

    seat = null;
  };

  thinkpadL14 = {
    hostname = "L14";
    location = geolocation.piracicaba;

    identityFile = "~/.ssh/id_ed25519.L14";
    gitKey = "heitorpbittencourt@gmail.com";
    gpgPinentry = "qt";

    amdGpu = "card0";
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
}
