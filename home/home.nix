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

    # Programming
    nil # Nix LSP
    nixfmt

    # Hyprland software
    hyprlock
    hyprshot
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  programs.kitty.enable = true;
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

  services.elephant.enable = true;
  services.walker = {
    enable = true;
    enableElephantIntegration = config.services.elephant.enable;
    systemd.enable = true;
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          path = "${config.home.homeDirectory}/Pictures/Wallpapers/OuterWildsWallpaper.jpg";
        }
      ];
    };
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

            WG_LINE=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | grep ':wireguard:')

            if [[ -n "$WG_LINE" ]]; then
                WG_DEVICE=$(cut -d: -f3 <<< "$WG_LINE")

                if ping -c 1 -W 2 "$REMOTE_HOST" > /dev/null 2>&1; then
                    PRIVATE_IP=$(nmcli -g IP4.ADDRESS device show "$WG_DEVICE" | cut -d/ -f1)
                    printf '{"text":"","class":"connected","tooltip":"WireGuard VPN active (%s)"}\n' "$PRIVATE_IP"
                else
                    printf '{"text":"","class":"disconnected","tooltip":"WireGuard VPN not connected"}\n'
                fi
            else
                printf '{"text":"󰂭","class":"inactive","tooltip":"WireGuard VPN inactive"}\n'
            fi
          '';
        };
        waybarVpnToggle = pkgs.writeShellApplication {
          name = "waybar-vpn-toggle";
          text = ''
            ACTIVE_WG=$(nmcli -t -f NAME,TYPE connection show --active | grep ':wireguard$' | cut -d: -f1)

            if [[ -n "$ACTIVE_WG" ]]; then
                nmcli connection down "$ACTIVE_WG"
            else
                WG_NAME=$(nmcli -t -f NAME,TYPE connection show | grep ':wireguard$' | head -n1 | cut -d: -f1)
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
          height = 40; # taller bar
          spacing = 0; # modules handle their own spacing now
          modules-left = [
            "ext/workspaces"
            "hyprland/window"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "cpu"
            "memory"
            "disk"
            "pulseaudio"
            "idle_inhibitor"
            "power-profiles-daemon"
            "battery"
            "network"
            "custom/vpn"
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
      #custom-vpn {
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
      #custom-vpn:hover {
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
      #custom-vpn.disconnected{ color: #6c7086; }

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
        input = {
          kb_layout = kb.layout;
          kb_variant = kb.variant;
          kb_options = kb.options;
        };
      };

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
