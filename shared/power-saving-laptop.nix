# Power saving services for my laptop
{...}: {
  services.power-profiles-daemon.enable = false; # Replaced by tlp
  services.upower.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Allow CPU turbo-boost (Intel) / turbo core (AMD)
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;

      # Help save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };
}
