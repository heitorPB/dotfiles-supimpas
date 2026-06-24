{...}: {
  services.grafana = {
    enable = true;
    settings = {
      # TODO add anynomous user for seeing dashboards without login
      security = {
        # TODO set passwords and keys via sops
        admin_user = "h";
        admin_password = "test";
        secret_key = "bla";
      };
      server.http_addr = "0.0.0.0";
    };
    # TODO provision prometheus data source
    # TODO provision node-exporter-full 1860 dashboard
    # TODO provision some zfs dashboard
  };
}
