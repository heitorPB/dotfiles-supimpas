# Single source of thruth.
_:

# TODO turn this into a function for correctness
rec {
  geolocation = import ./geolocation.nix;

  desktop = {
    hostname = "desk03";
    location = geolocation.piracicaba;
  };

  thinkpadL14 = {
    hostname = "L14";
    location = geolocation.piracicaba;
  };
}
