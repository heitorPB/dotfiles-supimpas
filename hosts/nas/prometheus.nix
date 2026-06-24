{config, ...}: {
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "30s"; # Default is 1m
    scrapeConfigs = [
      {
        job_name = "node_exporter";
        static_configs = [
          {
            targets = ["localhost:${toString config.services.prometheus.exporters.node.port}"];
          }
        ];
      }
      {
        job_name = "zfs_exporter";
        static_configs = [
          {
            targets = ["localhost:${toString config.services.prometheus.exporters.zfs.port}"];
          }
        ];
      }
    ];
  };

  # Persist Prometheus data in NVMe
  environment.persistence = {
    "/var/persistent".directories = [
      {
        directory = "/var/lib/prometheus2";
        user = "prometheus";
        group = "prometheus";
        mode = "0700";
      }
    ];
  };
}
