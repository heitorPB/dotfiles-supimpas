{ machine, lib, ... }:
let
  hasSeat = machine.seat != null;
in
{
  programs.i3status-rust = lib.mkIf (hasSeat) {
    enable = true;
    bars = {
      main = {
        settings = {
          theme.theme = "ctp-mocha"; # Catppuccin FTW!
          icons.icons = "awesome6";
        };
        blocks = [
          #{
          #  block = "toggle";
          #  format = " $icon";
          #  command_state = "${nmcli} radio wifi | ${grep} '^d'";
          #  command_on = "${nmcli} radio wifi off";
          #  command_off = "${nmcli} radio wifi on";
          #  interval = 5;
          #}
          #{
          #  block = "docker";
          #  interval = 5;
          #  format = "$icon  $running.eng(w:2)/$total.eng(w:2)";
          #  socket_path = "/var/run/user/1000/podman/podman.sock";
          #}
          {
            # Hardcode tun0 to show vpn network only if it exists.
            # The `missing_format` below takes care of not showing anything if
            # there's no tun0 device.
            block = "net";
            device = "tun";
            format = "$icon  $device  $ip  $ipv6 ";
            missing_format = "";
            interval = 30;
          }
          {
            # Hardcode wlan0 to show wireless network only if it exists.
            # The `missing_format` below takes care of not showing anything if
            # there's no wlan0 device.
            # TODO: move this to ssot
            block = "net";
            device = "wlan0";
            format = "$icon   $ssid ($signal_strength.eng(w:4))";
            missing_format = "";
            interval = 5;
          }
          {
            # Net up/down speed
            block = "net";
            device = machine.mainNetworkInterface;
            format = "^icon_net_down  $speed_down.eng(w:4,prefix:K)  ^icon_net_up  $speed_up.eng(w:4,prefix:K)";
            format_alt = " $ip  $ipv6";
            missing_format = "";
            interval = 5;
          }
          {
            block = "cpu";
            interval = 2;
            format = "$icon  $utilization.eng(w:4) ($frequency.eng(w:3))";
          }
        ] ++ (lib.lists.optional (machine.cpuSensor != null)
          {
            block = "temperature";
            format = "$icon $max";
            good = 40;
            idle = 50; # Above this temp, bg gets blue
            info = 65; # Above this temp, bg gets yellow
            warning = 80; # Above this temp, bg gets red
            chip = machine.cpuSensor;
            interval = 5;
          }
        ) ++ (lib.lists.optional (machine.amdGpu != null)
          {
            # GPU utilization
            # NOTE: if this block crashes, check card number in /sys/class/drm/
            #       and update ssot if needed
            block = "amd_gpu";
            device = machine.amdGpu;
            format = "$icon   $utilization.eng(w:4)";
            format_alt = "$icon   $vram_used.eng(w:3,u:B,p:Mi)/$vram_total.eng(w:1,u:B,p:Gi)";
            interval = 2;
          }
        ) ++ (lib.lists.optional (machine.amdGpuSensor != null)
          {
            block = "temperature";
            format = "$icon $max";
            good = 40;
            idle = 50; # Above this temp, bg gets blue
            info = 65; # Above this temp, bg gets yellow
            warning = 80; # Above this temp, bg gets red
            chip = machine.amdGpuSensor;
            interval = 5;
          }
        ) ++ (lib.lists.optional (machine.nvidiaGpu != null)
          {
            block = "nvidia_gpu";
            gpu_id = machine.nvidiaGpu;
            format = "$icon  $utilization $memory $temperature";
          }
        ) ++ [
          {
            # Screen brightness
            block = "backlight";
            format = "$icon $brightness.eng(w:4)";
            invert_icons = true; # Needed due to dark theme
            minimum = 1;
            cycle = [ 25 50 75 100 ];
          }
          #{
          #  # i3status-rs is buggy with gammastep :(
          #  # https://github.com/greshake/i3status-rust/issues/1397
          #  block = "hueshift"; # Screen temperature
          #  step = 50;
          #  click_temp = 4000;
          #}
        ] ++ [
          {
            block = "memory";
            interval = 2;
            format = "$icon  $mem_used.eng(w:3,u:B,p:Gi)/$mem_total.eng(w:2,u:B,p:Gi) ($mem_used_percents.eng(w:4))";
            format_alt = "$icon_swap $swap_used.eng(w:2,u:B,p:Gi)/$swap_total.eng(w:2,u:B,p:Gi) ($swap_used_percents.eng(w:1))";
            warning_mem = 75;
            critical_mem = 90;
          }
          {
            block = "disk_space";
            interval = 20;
            format = "$icon $available";
            path = "/";
            warning = 20.0;
            alert = 10.0;
          }
        ] ++ (map
          (sensor: {
            block = "temperature";
            format = "$icon $max";
            chip = sensor;
            interval = 3;
            idle = 37;
            info = 41;
            warning = 44;
          })
          machine.nvmeSensors
        ) ++ [
          {
            # Output volume
            block = "sound";
            format = "$icon $output_name {$volume.eng(w:4)|}";
            # TODO: format_alt: https://github.com/greshake/i3status-rust/pull/2041
            headphones_indicator = true;
            mappings = {
              # Turn weird output_names into human readable ones
              "alsa_output.pci-0000_07_00.6.analog-stereo" = " "; # L14's analog stereo out
              "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink" = " "; # G3's analog stereo out
              "bluez_output.78_2B_64_14_F3_96.1" = ""; # Bose NC700, bluetooth out
              "bluez_output.04_CB_88_6F_C2_70.1" = " speaker"; # JBL Go 2 speaker, bluetooth out
            };
          }
          {
            # Microphone
            block = "sound";
            format = "$icon $output_name {$volume.eng(w:4)|}";
            device_kind = "source"; # Microphone is a source
            mappings = {
              "alsa_input.pci-0000_07_00.6.analog-stereo" = " "; # L14's analog stereo in
              "alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source" =" "; # G3's analog stereo in
              "alsa_input.usb-046d_Logitech_BRIO_C8F19D30-03.analog-stereo" = "  Brio"; # Brio Webcam in
              "bluez_input.78:2B:64:14:F3:96" = ""; # Bose NC700, bluetooth mic
              "bluez_input.04:CB:88:6F:C2:70" = " JBL borked"; # JBL Go 2 speaker provides a broken source
            };
          }
          {
            # TODO make this block only if hasBattery, use ssot
            block = "battery";
            format = "$icon   $percentage";
            not_charging_format = "$icon   $percentage";
            interval = 5;
            device = machine.battery;
          }
          {
            block = "time";
            interval = 1;
            format = "$icon $timestamp.datetime(f:'%a %b %d %H:%M:%S %:::z')";
          }
        ];
      };
    };
  };
}
