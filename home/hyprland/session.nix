{ config, pkgs, ... }:

{
  programs.wleave = {
    enable = true;

    settings = {
      margin = 200;
      buttons-per-row = "1/1";
      delay-command-ms = 100;
      close-on-lost-focus = true;
      show-keybinds = true;
      no-version-info = true;
      buttons = [
        {
          label = "lock";
          action = "loginctl lock-session";
          text = "Lock";
          keybind = "l";
          icon = "${pkgs.wleave}/share/wleave/icons/lock.svg";
        }
        {
          label = "logout";
          action = "loginctl terminate-user $USER";
          text = "Logout";
          keybind = "e";
          icon = "${pkgs.wleave}/share/wleave/icons/logout.svg";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
          icon = "${pkgs.wleave}/share/wleave/icons/reboot.svg";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
          icon = "${pkgs.wleave}/share/wleave/icons/shutdown.svg";
        }
      ];
    };

    style = ''
      /* ============================================================
         Window — dark glass backdrop, same base tone as the waybar
         islands and the swaync control-center panel
         ============================================================ */
      window {
        --accent-bg-color: #fab387;
        --accent-fg-color: #1e1e2e;

        background-color: rgba(46, 46, 46, 0.9);
      }

      /* ============================================================
         Buttons — glass pills. Each button tints itself off its own
         --view-fg-color (set per #id below), using color-mix() to
         build the same 0.28 border / 0.16→0.05 gradient / 0.20 hover
         ratios used everywhere else in the theme.
         ============================================================ */
      button {
        --view-fg-color: #f5e0dc;

        color: var(--view-fg-color);
        background: linear-gradient(135deg,
                      color-mix(in srgb, var(--view-fg-color) 16%, transparent),
                      color-mix(in srgb, var(--view-fg-color) 5%, transparent));
        border: 1px solid color-mix(in srgb, var(--view-fg-color) 28%, transparent);
        border-radius: 18px;
        margin: 8px;
        padding: 20px 28px;
        box-shadow:
          0 4px 10px rgba(0, 0, 0, 0.35),
          inset 0 1px 0 rgba(255, 255, 255, 0.06);
        transition: background-color 0.2s ease, border-color 0.2s ease, color 0.2s ease;
      }

      button label.action-name {
        font-size: 24px;
        font-weight: 700;
      }

      button label.keybind {
        padding: 2px 8px;
        border-radius: 8px;
        font-size: 20px;
        font-family: monospace;
        font-weight: 700;
        background-color: var(--view-fg-color);
        color: #1e1e2e;
        opacity: 0.75;
      }

      button:hover label.keybind,
      button:focus label.keybind {
        opacity: 1;
      }

      button:focus,
      button:hover {
        background: linear-gradient(135deg,
                      color-mix(in srgb, var(--view-fg-color) 24%, transparent),
                      color-mix(in srgb, var(--view-fg-color) 10%, transparent));
        border-color: color-mix(in srgb, var(--view-fg-color) 45%, transparent);
      }

      button:active {
        color: var(--accent-fg-color);
        background-color: var(--accent-bg-color);
        border-color: var(--accent-bg-color);
        box-shadow: inset 0 2px 6px rgba(0, 0, 0, 0.35);
      }

      /* ============================================================
         Per-action accents — Catppuccin Mocha, same palette used in
         waybar.css and swaync's style.css
         ============================================================ */
      button#shutdown {
        --view-fg-color: #f38ba8; /* red */
      }
      button#hibernate {
        --view-fg-color: #89b4fa; /* blue */
      }
      button#reboot {
        --view-fg-color: #a6e3a1; /* green */
      }
      button#lock {
        --view-fg-color: #f9e2af; /* yellow */
      }
      button#logout {
        --view-fg-color: #fab387; /* peach — the theme's hero accent */
      }
      button#suspend {
        --view-fg-color: #cba6f7; /* mauve */
      }
    '';
  };

  services.hypridle = {
    enable = true;
    systemdTarget = config.wayland.systemd.target;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        ignore_dbus_inhibit = false;
        before_sleep_cmd = "loginctl lock-session";
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
          on-timeout = "loginctl lock-session";
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
