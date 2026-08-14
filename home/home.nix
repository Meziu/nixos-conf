{ config, lib, pkgs, ... }:

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
    zed-editor
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

    # Hyprland software
    hyprlock
    hyprpaper
    hyprshot
  ];

  programs.kitty.enable = true;
  programs.discord.enable = true;

  services.elephant.enable = true;
  services.walker = {
    enable = true;
    enableElephantIntegration = config.services.elephant.enable;
    systemd.enable = true;
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

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
        ];

        "ext/workspaces" = {
          format = "{icon}";
          "on-scroll-up" = "hyprctl dispatch 'hl.dsp.focus({workspace=\"e-1\"})' ";
          "on-scroll-down" = "hyprctl dispatch 'hl.dsp.focus({workspace=\"e+1\"})' ";
          "all-outputs" = true;
          "on-click" = "activate";
          "active-only" = false;
        };

        "memory" = {
          "tooltip-format" = "{used:0.1f}G / {total:0.1f}G used";
        };

        "power-profiles-daemon" = {
          format = "{icon}";
          tooltip = true;
          "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";

          "format-icons" = {
              "default" = "";      # Bolt (Fallback/Unknown)
              "performance" = "";  # Bolt
              "balanced" = "";     # Balance Scale
              "power-saver" = "";   # Leaf
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
            "format-icons" = ["" "" "" "" ""];

            "tooltip-format" = "{timeTo} - {capacity}%";
        };
      };
    };

    style = "
      #battery {
          font-family: \"Font Awesome 6 Free Solid\", \"Font Awesome 6 Free\";
          color: #a6e3a1;
      }
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

      #power-profiles-daemon {
          font-family: \"Font Awesome 6 Free Solid\", \"Font Awesome 6 Free\";
          padding: 0 8px;
      }

      #power-profiles-daemon.performance {
          color: #f38ba8;
      }
      #power-profiles-daemon.balanced {
          color: #f9e2af;
      }
      #power-profiles-daemon.power-saver {
          color: #a6e3a1;
      }

      @keyframes blink {
          to { opacity: 0.4; }
      }
    ";
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
