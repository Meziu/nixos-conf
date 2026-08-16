{
  config,
  lib,
  pkgs,
  ...
}:

let
  kb = import ../modules/apple-aluminum-keyboard.nix;
in
{
  nixpkgs.config.allowUnfree = true;

  home.username = "andreaciliberti";
  home.homeDirectory = "/home/andreaciliberti";

  home.keyboard = {
    layout = kb.layout;
    variant = kb.variant;
    options = [ kb.options ]; # home.keyboard.options wants a list
  };

  home.packages = with pkgs; [
    kdePackages.kate
    kdePackages.filelight
    vlc
    audacity
    cheese
    gimp
    imhex
    prismlauncher
    spotify
    telegram-desktop
    deluge
    obsidian
    chromium
    libreoffice
    thunderbird
    eog # gnome image viewer
    papers # gnome document viewer
    gnome-system-monitor
    gnome-clocks
    gparted
    gnome-disk-utility
    popsicle
    deja-dup
    protonup-ng
    rustup
    obs-studio
    networkmanagerapplet

    # Programming
    nil # Nix LSP
    nixfmt

    # Hyprland software
    hyprlock
    hyprshot
    libnotify
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  services.playerctld.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = 0.6;
    };
  };
  programs.discord.enable = true;

  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
    ];

    userSettings = {
      "cli_default_open_behavior" = "existing_window";
      "project_panel" = {
        "dock" = "left";
      };
      "outline_panel" = {
        "dock" = "left";
      };
      "collaboration_panel" = {
        "dock" = "left";
      };
      "git_panel" = {
        "dock" = "left";
      };
      "calls" = {
        "mute_on_join" = true;
      };
      "show_edit_predictions" = false;
      "ui_font_size" = 16;
      "buffer_font_size" = 16;
      "theme" = {
        "mode" = "system";
        "light" = "One Light";
        "dark" = "Ayu Dark";
      };
      "disable_ai" = true;
      languages = {
        Nix = {
          language_servers = [
            "nil"
            "!nixd"
          ];
          formatter = {
            external = {
              command = "nixfmt";
            };
          };
        };
      };
    };
  };

  services.network-manager-applet.enable = true;

  services.elephant.enable = true;
  services.walker = {
    enable = true;
    enableElephantIntegration = config.services.elephant.enable;
    systemd.enable = true;
  };

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
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
          icon = "${pkgs.wleave}/share/wleave/icons/shutdown.svg";
        }
      ];
    };
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

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = [
        "${config.home.homeDirectory}/Pictures/Wallpapers/OuterWildsWallpaper.jpg"
      ];
      wallpaper = [
        {
          monitor = "";
          path = "${config.home.homeDirectory}/Pictures/Wallpapers/OuterWildsWallpaper.jpg";
        }
      ];
    };
  };

  services.swaync = {
    enable = true;

    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      widgets = [
        "title"
        "dnd"
        "mpris"
        "notifications"
      ];
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      hide-on-clear = true;
      fit-to-screen = false;
      control-center-height = -1;
      control-center-width = 380;
      control-center-margin-top = 8;
      control-center-margin-right = 8;
      control-center-margin-bottom = 8;
      control-center-margin-left = 0;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      widget-config = {
        notifications = {
          vexpand = false;
        };
      };
    };

    style = ''
      * {
        font-family: "Symbols Nerd Font", "UbuntuMono Nerd Font";
        font-size: 18px;
        font-weight: bold;
        min-height: 0;
      }

      /* ============================================================
         Top-level windows stay fully transparent so only the pills
         below are visible, same trick as window#waybar
         ============================================================ */
      window.control-center,
      .floating-notifications.background,
      .blank-window {
        background: transparent;
      }

      /* ============================================================
         Control center — the big glass pill that holds everything.
         Same gradient/border/shadow recipe as the waybar islands.
         ============================================================ */
      .control-center {
        background: linear-gradient(135deg,
                      rgba(30, 30, 46, 0.90),
                      rgba(30, 30, 46, 0.97));
        border: 1px solid rgba(250, 179, 135, 0.28);
        border-radius: 18px;
        padding: 6px;
        box-shadow:
          0 4px 10px rgba(0, 0, 0, 0.35),
          inset 0 1px 0 rgba(255, 255, 255, 0.06);
      }

      .control-center-list {
        background: transparent;
        padding: 2px 4px;
      }

      .control-center-list-placeholder {
        color: #6c7086;
        opacity: 0.7;
        font-weight: 500;
      }

      /* ============================================================
         Scrollbar — thin glass thumb, only appears once the pending
         notifications actually overflow control-center-height
         ============================================================ */
      scrollbar {
        background: transparent;
        border: none;
      }
      scrollbar slider {
        background-color: rgba(250, 179, 135, 0.35);
        border-radius: 10px;
        min-width: 6px;
        min-height: 6px;
      }
      scrollbar slider:hover {
        background-color: rgba(250, 179, 135, 0.55);
      }

      /* ============================================================
         Title widget — "Notifications" heading + Clear All button
         ============================================================ */
      .widget-title {
        margin: 6px 10px 2px 10px;
        padding: 4px 8px;
      }
      .widget-title > label {
        font-size: 16px;
        font-weight: 700;
        color: #fab387;
      }
      .widget-title > button {
        padding: 4px 12px;
        border-radius: 12px;
        background: linear-gradient(135deg,
                      rgba(250, 179, 135, 0.16),
                      rgba(250, 179, 135, 0.05));
        border: 1px solid rgba(250, 179, 135, 0.28);
        color: #f5e0dc;
        font-size: 13px;
        font-weight: 600;
        box-shadow: none;
        transition: background-color 0.2s ease;
      }
      .widget-title > button:hover {
        background-color: rgba(250, 179, 135, 0.20);
      }

      /* ============================================================
         Do Not Disturb toggle
         ============================================================ */
      .widget-dnd {
        margin: 2px 14px 6px 14px;
      }
      .widget-dnd > label {
        color: #f5e0dc;
        font-size: 13px;
        font-weight: 600;
      }
      .widget-dnd > switch {
        border-radius: 30px;
        background: rgba(255, 255, 255, 0.08);
        border: 1px solid rgba(250, 179, 135, 0.2);
        background-image: none;
        box-shadow: none;
      }
      .widget-dnd > switch:checked {
        background-color: #fab387;
        border-color: #fab387;
      }
      .widget-dnd > switch slider {
        background: #1e1e2e;
        border-radius: 100%;
      }

      /* ============================================================
         Plain label widget
         ============================================================ */
      .widget-label {
        margin: 4px 14px;
      }
      .widget-label > label {
        color: #cdd6f4;
        font-size: 13px;
      }

      /* ============================================================
         Mpris — media player card, same recipe as a notification
         ============================================================ */
      .widget-mpris {
        margin: 6px 10px;
      }
      .widget-mpris-player {
        background: linear-gradient(135deg,
                      rgba(250, 179, 135, 0.14),
                      rgba(250, 179, 135, 0.04));
        border: 1px solid rgba(250, 179, 135, 0.22);
        border-radius: 14px;
        padding: 10px;
        box-shadow:
          0 4px 10px rgba(0, 0, 0, 0.30),
          inset 0 1px 0 rgba(255, 255, 255, 0.05);
      }
      .widget-mpris-title {
        color: #f5e0dc;
        font-weight: 700;
        font-size: 14px;
      }
      .widget-mpris-subtitle {
        color: #cdd6f4;
        font-size: 12px;
        opacity: 0.8;
      }
      .widget-mpris-player > button,
      .widget-mpris-player > box > button {
        background: rgba(250, 179, 135, 0.12);
        border-radius: 10px;
        color: #f5e0dc;
      }
      .widget-mpris-player > button:hover,
      .widget-mpris-player > box > button:hover {
        background: rgba(250, 179, 135, 0.22);
      }

      /* ============================================================
         Quick action button grid
         ============================================================ */
      .widget-buttons-grid {
        margin: 6px 10px;
      }
      .widget-buttons-grid > flowbox > flowboxchild > button {
        background: linear-gradient(135deg,
                      rgba(250, 179, 135, 0.14),
                      rgba(250, 179, 135, 0.04));
        border: 1px solid rgba(250, 179, 135, 0.22);
        border-radius: 14px;
        color: #f5e0dc;
        padding: 8px;
        transition: background-color 0.2s ease;
      }
      .widget-buttons-grid > flowbox > flowboxchild > button:hover {
        background-color: rgba(250, 179, 135, 0.2);
      }
      .widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked {
        background: #fab387;
        color: #1e1e2e;
        font-weight: 700;
      }

      /* ============================================================
         Volume / backlight sliders
         ============================================================ */
      .widget-volume,
      .widget-backlight {
        margin: 4px 14px;
        color: #f5e0dc;
      }
      .widget-volume > box > slider,
      .widget-backlight > box > slider {
        background: #fab387;
        border-radius: 100%;
        min-width: 14px;
        min-height: 14px;
      }
      .widget-volume > box > trough,
      .widget-backlight > box > trough {
        background: rgba(255, 255, 255, 0.08);
        border-radius: 10px;
        min-height: 6px;
      }
      .widget-volume > box > trough > highlight,
      .widget-backlight > box > trough > highlight {
        background: #fab387;
        border-radius: 10px;
      }

      /* ============================================================
         Inhibitors widget
         ============================================================ */
      .widget-inhibitors {
        margin: 4px 14px;
      }
      .widget-inhibitors > box > button {
        background: rgba(250, 179, 135, 0.12);
        border-radius: 12px;
        color: #f5e0dc;
      }
      .widget-inhibitors > box > button:hover {
        background: rgba(250, 179, 135, 0.22);
      }

      /* ============================================================
         Individual notifications — pill cards. Same classes are used
         inside the control center list and for floating popups, so
         one block styles both.
         ============================================================ */
      .notification-row {
        outline: none;
        margin: 5px 8px;
        padding: 0;
      }

      .notification-row:focus,
      .notification-row:hover {
        background: transparent;
      }

      .notification {
        background: transparent;
        border-radius: 14px;
        padding: 0;
      }

      .notification-content {
        background: linear-gradient(135deg,
                      rgba(250, 179, 135, 0.14),
                      rgba(250, 179, 135, 0.04));
        border: 1px solid rgba(250, 179, 135, 0.22);
        border-radius: 14px;
        padding: 10px 12px;
        box-shadow:
          0 4px 10px rgba(0, 0, 0, 0.30),
          inset 0 1px 0 rgba(255, 255, 255, 0.05);
        transition: background-color 0.2s ease, border-color 0.2s ease;
      }

      .notification-row:hover .notification-content {
        background: linear-gradient(135deg,
                      rgba(250, 179, 135, 0.20),
                      rgba(250, 179, 135, 0.07));
        border-color: rgba(250, 179, 135, 0.4);
      }

      /* Critical notifications pulse, same language as #battery.critical */
      .notification.critical .notification-content {
        border-color: rgba(243, 139, 168, 0.55);
        animation: nc-blink 1.4s infinite alternate;
      }
      @keyframes nc-blink {
        to { border-color: rgba(243, 139, 168, 0.9); }
      }

      .notification-default-action {
        padding: 0;
        background: transparent;
        border-radius: 14px;
      }

      .notification-action {
        padding: 6px 10px;
        margin: 6px 4px 0 4px;
        background: rgba(250, 179, 135, 0.10);
        border: 1px solid rgba(250, 179, 135, 0.20);
        border-radius: 10px;
        color: #f5e0dc;
        font-size: 12px;
        font-weight: 600;
        transition: background-color 0.2s ease;
      }
      .notification-action:hover {
        background: rgba(250, 179, 135, 0.22);
      }

      .close-button {
        background: rgba(250, 179, 135, 0.14);
        color: #f5e0dc;
        border-radius: 100%;
        min-width: 20px;
        min-height: 20px;
        padding: 0;
        box-shadow: none;
        text-shadow: none;
      }
      .close-button:hover {
        background: rgba(250, 179, 135, 0.30);
      }

      .notification-icon,
      .image {
        border-radius: 10px;
      }

      .body-image {
        margin-top: 6px;
        border-radius: 10px;
      }

      .summary {
        color: #f5e0dc;
        font-weight: 700;
        font-size: 14px;
        text-shadow: none;
        background: transparent;
      }

      .time {
        color: #6c7086;
        font-size: 11px;
        text-shadow: none;
        background: transparent;
      }

      .body {
        color: #cdd6f4;
        font-size: 12px;
        font-weight: 500;
        text-shadow: none;
        background: transparent;
        opacity: 0.9;
      }

      .app-name {
        color: #fab387;
        font-size: 11px;
        font-weight: 700;
      }

      .progress-bar {
        background: rgba(255, 255, 255, 0.08);
        border-radius: 10px;
        min-height: 4px;
      }
      .progress-bar-value {
        background: #fab387;
        border-radius: 10px;
      }

      /* ============================================================
         Tooltips — same glassy language as waybar
         ============================================================ */
      tooltip {
        background: rgba(30, 30, 46, 0.92);
        border: 1px solid rgba(250, 179, 135, 0.35);
        border-radius: 12px;
      }
      tooltip label {
        color: #cdd6f4;
        padding: 6px 10px;
        font-size: 13px;
      }
    '';
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings =
      let
        waybarVpnStatus = pkgs.writeShellApplication {
          name = "waybar-vpn-status";
          text = ''
            REMOTE_HOST="10.214.101.1"  # set to an address only reachable through the tunnel

            WG_LINE=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | grep ':wireguard:' || true)

            if [[ -n "$WG_LINE" ]]; then
                WG_DEVICE=$(cut -d: -f3 <<< "$WG_LINE")

                if ping -c 1 -W 2 "$REMOTE_HOST" > /dev/null 2>&1; then
                    PRIVATE_IP=$(nmcli -g IP4.ADDRESS device show "$WG_DEVICE" | cut -d/ -f1 || true)
                    printf '{"text":"","class":"connected","tooltip":"WireGuard VPN active (%s)"}\n' "$PRIVATE_IP"
                else
                    printf '{"text":"","class":"disconnected","tooltip":"WireGuard VPN not connected"}\n'
                fi
            else
                printf '{"text":"󰂭","class":"off","tooltip":"WireGuard VPN inactive"}\n'
            fi
          '';
        };
        waybarVpnToggle = pkgs.writeShellApplication {
          name = "waybar-vpn-toggle";
          text = ''
            ACTIVE_WG=$(nmcli -t -f NAME,TYPE connection show --active | grep ':wireguard$' | cut -d: -f1 || true)

            if [[ -n "$ACTIVE_WG" ]]; then
                nmcli connection down "$ACTIVE_WG"
            else
                WG_NAME=$(nmcli -t -f NAME,TYPE connection show | grep ':wireguard$' | head -n1 | cut -d: -f1 || true)
                if [[ -n "$WG_NAME" ]]; then
                    nmcli connection up "$WG_NAME"
                fi
            fi
          '';
        };
      in
      {
        mainBar = {
          layer = "top";
          position = "top";
          height = 40;
          spacing = 0; # modules handle their own spacing
          margin-left = 4;
          margin-right = 4;
          margin-top = 4;
          margin-bottom = 0;

          modules-left = [
            "ext/workspaces"
            "hyprland/window"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "custom/mediaplayer"
            "cpu"
            "memory"
            "disk"
            "tray"
            "pulseaudio"
            "idle_inhibitor"
            "power-profiles-daemon"
            "battery"
            "network"
            "custom/vpn"
            "custom/notification"
            "custom/logout"
          ];
          "ext/workspaces" = {
            format = "{icon}";
            "on-scroll-up" = "hyprctl dispatch 'hl.dsp.focus({workspace=\"e-1\"})' ";
            "on-scroll-down" = "hyprctl dispatch 'hl.dsp.focus({workspace=\"e+1\"})' ";
            "all-outputs" = true;
            "on-click" = "activate";
            "active-only" = false;
          };
          "clock" = {
            format = "{:%A %d %B  %H:%M}";
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };
          "memory" = {
            "tooltip-format" = "{used:0.1f}G / {total:0.1f}G used";
          };
          "power-profiles-daemon" = {
            format = "{icon}";
            tooltip = true;
            "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";
            "format-icons" = {
              "default" = ""; # Bolt (Fallback/Unknown)
              "performance" = ""; # Bolt
              "balanced" = ""; # Balance Scale
              "power-saver" = ""; # Leaf
            };
          };
          "battery" = {
            "states" = {
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{icon} {capacity}%";
            "format-charging" = "\uf0e7 {capacity}%";
            "format-plugged" = "\uf1e6 {capacity}%";
            "format-icons" = [
              ""
              ""
              ""
              ""
              ""
            ];

            "tooltip-format" = "{timeTo} - {capacity}%";
          };
          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
            tooltip-format-activated = "Idle inhibited";
            tooltip-format-deactivated = "Idle possible";
          };
          "network" = {
            format-wifi = "{icon} {signalStrength}%";
            format-ethernet = "󰈀 {ifname}";
            format-disconnected = "󰤮 Offline";
            format-icons = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            tooltip-format-wifi = "{essid} ({signalStrength}%)\n↓ {bandwidthDownBytes}  ↑ {bandwidthUpBytes}";
            tooltip-format-ethernet = "{ifname}  {ipaddr}/{cidr}";
            tooltip-format-disconnected = "Disconnected";
            on-click = "nm-applet";
          };
          "custom/vpn" = {
            exec = "${waybarVpnStatus}/bin/waybar-vpn-status";
            on-click = "${waybarVpnToggle}/bin/waybar-vpn-toggle";
            return-type = "json";
            interval = 5;
            format = "{}";
            tooltip = true;
          };
          "custom/mediaplayer" = {
            exec = "playerctl metadata --format \"{{ title }}\" -s";
            hide-empty-text = true;
            interval = 1;
            on-click = "playerctl play-pause";
            format = "󰝚 {}";
            tooltip = true;
          };
          "custom/logout" = {
            "format" = "⏻";
            "on-click" = "wleave";
            "tooltip" = false;
          };
          "custom/notification" = {
            "tooltip" = false;
            "format" = "{} {icon}";
            "format-icons" = {
              "notification" = "";
              "none" = "";
              "dnd-notification" = "";
              "dnd-none" = "";
              "inhibited-notification" = "";
              "inhibited-none" = "";
              "dnd-inhibited-notification" = "";
              "dnd-inhibited-none" = "";
            };
            "return-type" = "json";
            "exec-if" = "which swaync-client";
            "exec" = "swaync-client -swb";
            "on-click" = "sleep 0.1; swaync-client -t -sw";
            "on-click-right" = "swaync-client -d -sw";
            "escape" = true;
          };
        };
      };

    style = ''
      * {
        font-family: "Symbols Nerd Font", "UbuntuMono Nerd Font";
        font-size: 18px;
        font-weight: bold;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      /* ============================================================
        The three "islands": modules-left / modules-center / modules-right
        These are waybar's actual container boxes, so styling them
        directly is what gives the divided, floating-pill look.
        ============================================================ */
      .modules-left,
      .modules-center,
      .modules-right {
        background: linear-gradient(135deg,
                      rgba(250, 179, 135, 0.16),
                      rgba(250, 179, 135, 0.05));
        border: 1px solid rgba(250, 179, 135, 0.28);
        border-radius: 18px;
        margin: 7px 6px;
        padding: 0 6px;
        box-shadow:
          0 4px 10px rgba(0, 0, 0, 0.35),
          inset 0 1px 0 rgba(255, 255, 255, 0.06);
      }

      /* ============================================================
        Shared per-module box: padding + rounded hover state
        ============================================================ */
      #workspaces,
      #window,
      #clock,
      #cpu,
      #memory,
      #disk,
      #pulseaudio,
      #idle_inhibitor,
      #power-profiles-daemon,
      #battery,
      #network,
      #tray,
      #custom-vpn,
      #custom-mediaplayer,
      #custom-logout,
      #custom-notification {
        padding: 4px 12px;
        margin: 4px 2px;
        border-radius: 14px;
        color: #f5e0dc;
        transition: background-color 0.2s ease, color 0.2s ease;
      }

      #workspaces:hover,
      #window:hover,
      #clock:hover,
      #cpu:hover,
      #memory:hover,
      #disk:hover,
      #pulseaudio:hover,
      #idle_inhibitor:hover,
      #power-profiles-daemon:hover,
      #battery:hover,
      #network:hover,
      #custom-vpn:hover,
      #custom-mediaplayer:hover,
      #custom-logout:hover,
      #custom-notification:hover,
      window > menu > menuitem:hover,
      window > menu > menuitem:hover > check,
      window > menu > menuitem:hover > box,
      window > menu > menuitem:hover > box > *,
      /*
      window > menu > menuitem:hover > label,
      window > menu > menuitem:hover > label > *,
      */
      window > menu > menuitem:hover > arrow {
        background-color: rgba(250, 179, 135, 0.16);
      }

      /* ============================================================
        Workspaces
        ============================================================ */
      #workspaces {
        padding: 4px 6px;
      }
      #workspaces button {
        padding: 0 7px;
        margin: 0 1px;
        border-radius: 10px;
        color: rgba(245, 224, 220, 0.5);
        background: transparent;
      }
      #workspaces button.active {
        color: #1e1e2e;
        background-color: #fab387;
        font-weight: 700;
      }
      #workspaces button.empty {
        color: rgba(245, 224, 220, 0.25);
      }
      #workspaces button:hover {
        background-color: rgba(250, 179, 135, 0.18);
        color: #f5e0dc;
      }

      /* ============================================================
        Window title
        ============================================================ */
      #window {
        font-weight: 600;
        color: #cdd6f4;
      }

      /* ============================================================
        Clock — the centerpiece
        ============================================================ */
      #clock {
        font-weight: 700;
        color: #fab387;
        padding: 4px 18px;
      }

      /* ============================================================
        CPU / Memory / Disk
        ============================================================ */
      #cpu    { color: #94e2d5; }
      #memory { color: #cba6f7; }
      #disk   { color: #b4befe; }

      /* ============================================================
        Pulseaudio
        ============================================================ */
      #pulseaudio       { color: #f5c2e7; }
      #pulseaudio.muted { color: #6c7086; }

      /* ============================================================
        Idle inhibitor
        ============================================================ */
      #idle_inhibitor {
        color: #eba0ac;
      }
      #idle_inhibitor.activated {
        color: #fab387;
        background-color: rgba(250, 179, 135, 0.16);
      }

      /* ============================================================
        Network
        ============================================================ */
      #network.wifi         { color: #74c7ec; }
      #network.ethernet      { color: #94e2d5; }
      #network.disconnected,
      #network.disabled      { color: #6c7086; }

      #custom-vpn             { color: #6c7086; }
      #custom-vpn.connected   { color: #a6e3a1; }
      #custom-vpn.disconnected,
      #custom-vpn.off    { color: #6c7086; }

      /* ============================================================
        Power profiles daemon
        ============================================================ */
      #power-profiles-daemon.performance  { color: #f38ba8; }
      #power-profiles-daemon.balanced     { color: #f9e2af; }
      #power-profiles-daemon.power-saver  { color: #a6e3a1; }

      /* ============================================================
        Battery
        ============================================================ */
      #battery { color: #a6e3a1; }
      #battery.warning {
        color: #f9e2af;
      }
      #battery.critical {
        color: #f38ba8;
        animation: blink 1s infinite alternate;
      }
      #battery.charging {
        color: #89b4fa;
      }

      @keyframes blink {
        to { opacity: 0.4; }
      }

      /* ============================================================
        Logout
        ============================================================ */
      #custom-logout { color: #D9524C; }

      /* ============================================================
        Tooltips — same glassy language as the bar itself
        ============================================================ */
      tooltip {
        background: rgba(30, 30, 46, 0.92);
        border: 1px solid rgba(250, 179, 135, 0.35);
        border-radius: 12px;
      }
      tooltip label {
        color: #cdd6f4;
        padding: 6px 10px;
        font-size: 16px;
      }
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "lua";

    systemd.enable = true;

    settings = {
      config = {
        general = {
          gaps_in = 6;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "#F28C28";
        };

        decoration = {
          rounding = 10;
        };

        input = {
          kb_layout = kb.layout;
          kb_variant = kb.variant;
          kb_options = kb.options;
        };
      };

      layer_rule = [
        # wleave's fade out animation keeps it visible after locking
        {
          match = {
            namespace = "wleave";
          };
          no_anim = true;
        }
      ];

      on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline "function()\n  hl.exec_cmd(\"spice-vdagent\")\nend")
          ];
        }
      ];

      monitor = {
        output = "";
        mode = "1920x1080@60";
        position = "auto";
        scale = "1.0";
      };

      bind = [
        {
          _args = [
            "SUPER + RETURN"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"kitty\")")
          ];
        }
        {
          _args = [
            "SUPER + SUPER_L"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"walker\")")
          ];
        }
        {
          _args = [
            "SUPER + Q"
            (lib.generators.mkLuaInline "hl.dsp.window.kill()")
          ];
        }
        {
          _args = [
            "SUPER + G"
            (lib.generators.mkLuaInline "hl.dsp.window.float({action = \"toggle\"})")
          ];
        }
        {
          _args = [
            "SUPER + F"
            (lib.generators.mkLuaInline "hl.dsp.window.fullscreen({mode = fullscreen, action = \"toggle\"})")
          ];
        }

        # Window Binds
        {
          _args = [
            "SUPER + LEFT"
            (lib.generators.mkLuaInline "hl.dsp.focus({direction = \"left\"})")
          ];
        }
        {
          _args = [
            "SUPER + RIGHT"
            (lib.generators.mkLuaInline "hl.dsp.focus({direction = \"right\"})")
          ];
        }
        {
          _args = [
            "SUPER + UP"
            (lib.generators.mkLuaInline "hl.dsp.focus({direction = \"up\"})")
          ];
        }
        {
          _args = [
            "SUPER + DOWN"
            (lib.generators.mkLuaInline "hl.dsp.focus({direction = \"down\"})")
          ];
        }

        {
          _args = [
            "SUPER + SHIFT + LEFT"
            (lib.generators.mkLuaInline "hl.dsp.window.move({direction = \"left\"})")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + RIGHT"
            (lib.generators.mkLuaInline "hl.dsp.window.move({direction = \"right\"})")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + UP"
            (lib.generators.mkLuaInline "hl.dsp.window.move({direction = \"up\"})")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + DOWN"
            (lib.generators.mkLuaInline "hl.dsp.window.move({direction = \"down\"})")
          ];
        }

        # Workspace Binds
        {
          _args = [
            "SUPER + 1"
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 1})")
          ];
        }
        {
          _args = [
            "SUPER + 2"
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 2})")
          ];
        }
        {
          _args = [
            "SUPER + 3"
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 3})")
          ];
        }
        {
          _args = [
            "SUPER + 4"
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 4})")
          ];
        }
        {
          _args = [
            "SUPER + 5"
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 5})")
          ];
        }
        {
          _args = [
            "SUPER + 6"
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 6})")
          ];
        }
        {
          _args = [
            "SUPER + 7"
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 7})")
          ];
        }
        {
          _args = [
            "SUPER + 8"
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 8})")
          ];
        }
        {
          _args = [
            "SUPER + 9"
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 9})")
          ];
        }
        {
          _args = [
            "SUPER + 0"
            (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 10})")
          ];
        }

        {
          _args = [
            "SUPER + SHIFT + 1"
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 1})")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 2"
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 2})")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 3"
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 3})")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 4"
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 4})")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 5"
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 5})")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 6"
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 6})")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 7"
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 7})")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 8"
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 8})")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 9"
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 9})")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 0"
            (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 10})")
          ];
        }

        # Mouse Binds
        {
          _args = [
            "SUPER + mouse:272"
            (lib.generators.mkLuaInline "hl.dsp.window.drag()")
            {
              mouse = true;
            }
          ];
        }
        {
          _args = [
            "SUPER + mouse:273"
            (lib.generators.mkLuaInline "hl.dsp.window.resize()")
            {
              mouse = true;
            }
          ];
        }
      ];
    };
  };

  # Optional, hint Electron apps to use Wayland:
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  home.stateVersion = "26.05";
}
