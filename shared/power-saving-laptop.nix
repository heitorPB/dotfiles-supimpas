# Power saving services for my laptop
{ ... }:

{
  services.power-profiles-daemon.enable = false; # Replaced by tlp
  services.upower.enable = true;

  services.tlp.enable = false;

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        # Minimum CPU frequency when using battery, in kHz
        scaling_min_freq = 800000;

        # Experimental battery charging levels
        # NOTE: not all laptops are supported, currently only Lenovo. See
        # https://github.com/AdnanHodzic/auto-cpufreq/blob/v2.3.0/README.md#battery-charging-thresholds
        enable_thresholds = true;
        start_threshold = 20;
        stop_threshold = 80;
      };
      charger = {
        governor = "performance";
      };
    };
  };
}
