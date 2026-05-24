{...}: {
  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = ["systemd"];
      disabledCollectors = ["btrfs" "infiniband" "xfs"];
    };

    zfs.enable = true;
  };
}
