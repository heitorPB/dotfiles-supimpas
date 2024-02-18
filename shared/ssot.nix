# Single source of thruth.
_:

# TODO: turn this into a function for correctness
rec {
  geolocation = import ./geolocation.nix;

  desktop = {
    hostname = "desk03";
    location = geolocation.piracicaba;
    gitKey = "heitorpbittencourt@gmail.com";
    seat = null;
  };

  thinkpadL14 = {
    hostname = "L14";
    location = geolocation.piracicaba;
    gitKey = "heitorpbittencourt@gmail.com";

    amdGpu = "card0";
    battery = "BAT0";
    cpuSensor = "k10temp-pci-00c3";
    gpuSensor = "amdgpu-pci-0700";
    mainNetworkInterface = "wlan0";
    nvmeSensors = [ "nvme-pci-0100" ];
    seat = {
      notificationX = "right";
      notificationY = "top";
    };
  };
}
