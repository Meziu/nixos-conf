{ config, ... }:

let
  lockCmd = "qs -c ventureshell ipc call lockscreen lock";
in
{
  services.hypridle = {
    enable = true;
    systemdTarget = config.wayland.systemd.target;

    settings = {
      general = {
        lock_cmd = lockCmd;
        ignore_dbus_inhibit = false;
        before_sleep_cmd = lockCmd;
        after_sleep_cmd = "hyprctl dispatch hl.dsp.dpms({action = on})";
      };

      listener = [
        {
          timeout = 60;
          on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "brightnessctl -r"; # monitor backlight restore.
        }
        {
          timeout = 120;
          on-timeout = lockCmd;
        }
        {
          timeout = 300;
          on-resume = "hyprctl dispatch hl.dsp.dpms({action = on})";
          on-timeout = "hyprctl dispatch hl.dsp.dpms({action = off})";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
