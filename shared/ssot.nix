# Single source of thruth.
_:

# TODO: turn this into a function for correctness
# TODO: get rid of specs.nix ans just use this 
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
