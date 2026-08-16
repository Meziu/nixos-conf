{ pkgs, ... }:

{
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
          "cpu" = {
            tooltip = true;
          };
          "memory" = {
            "tooltip-format" = "{used:0.1f}G / {total:0.1f}G used";
            tooltip = true;
          };
          "disk" = {
            format = "{percentage_used}%";
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
            "format-charging" = " {capacity}%";
            "format-plugged" = " {capacity}%";
            "format-icons" = [
              ""
              ""
              ""
              ""
              ""
            ];
            "tooltip-format" = "{timeTo} - {capacity}%";
            interval = 5;
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
}
