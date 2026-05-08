# Settings for Tailscale _clients_.
# Note: this exposes all connections on tailscale0 interface. See
# https://nixos.wiki/wiki/Tailscale#Tailscale_bypasses_the_firewall_for_all_incoming_traffic_on_tailscale0
# for details. I will keep it until I figure out how to `tailscale serve
# --set-path` programmatically
{lib, ...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client";
  };

  environment.persistence = {
    "/var/persistent".directories = ["/var/lib/tailscale"];
  };
}
