{lib, ...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client";
  };

  environment.persistence = {
    "/var/persistent".directories = ["/var/lib/tailscale"];
  };
}
