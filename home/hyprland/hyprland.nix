{
  lib,
  pkgs,
  ...
}:

let
  kb = import ../../modules/apple-aluminum-keyboard.nix;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
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

          touchpad = {
            natural_scroll = true;
          };
        };

        ecosystem = {
          enforce_permissions = 1;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
      };

      permission = [
        {
          binary = "${pkgs.quickshell}/bin/.quickshell-wrapped";
          type = "screencopy";
          mode = "allow";
        }
        {
          binary = "${pkgs.hyprlock}/bin/hyprlock";
          type = "screencopy";
          mode = "allow";
        }
        {
          binary = "${pkgs.grim}/bin/grim";
          type = "screencopy";
          mode = "allow";
        }
        {
          binary = "${pkgs.hyprpicker}/bin/hyprpicker";
          type = "screencopy";
          mode = "allow";
        }
        {
          binary = "${pkgs.xdg-desktop-portal-hyprland}/libexec/.xdg-desktop-portal-hyprland-wrapped";
          type = "screencopy";
          mode = "allow";
        }
      ];

      animation = [
        {
          leaf = "fadeLayersOut"; # wleave takes so long it stays visible during lock
          enabled = true;
          speed = 2;
          bezier = "default";
        }
      ];

      on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline "function()\n  hl.exec_cmd(\"spice-vdagent\")\nend")
          ];
        }
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline "function()\n  hl.exec_cmd(\"deja-dup --gapplication-service\")\nend")
          ];
        }
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline "function()\n  hl.exec_cmd(\"blueman-applet\")\nend")
          ];
        }
      ];

      monitor = [
        {
          output = "eDP-1";
          mode = "preferred";
          position = "auto";
          scale = "1.0";
        }
        {
          output = "desc:LG Electronics E2250 004MAJMFW724";
          mode = "preferred";
          position = "auto-left";
          scale = "1.0";
        }
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = "auto";
        }
      ];

      workspace_rule = [
        {
          workspace = 1;
          monitor = "desc:LG Electronics E2250 004MAJMFW724";
        }
      ];

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
            (lib.generators.mkLuaInline "hl.dsp.window.close()")
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
        {
          _args = [
            "ALT + TAB"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("qs ipc -c qs-hyprview call expose cycle 1")'')
          ];
        }
        {
          _args = [
            "ALT + ALT_L"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("qs ipc -c qs-hyprview call expose select && qs ipc -c qs-hyprview call expose close")'')
            {
              release = true;
              transparent = true;
            }
          ];
        }
        {
          _args = [
            "Print"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("hyprshot -m region -o ~/Pictures/Screenshots")'')
          ];
        }
        {
          _args = [
            "XF86LaunchA"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("hyprshot -m region -o ~/Pictures/Screenshots")'')
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

        # SpecialKeys Binds
        {
          _args = [
            "XF86AudioPlay"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl play-pause\")")
          ];
        }
        {
          _args = [
            "XF86AudioNext"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl next\")")
          ];
        }
        {
          _args = [
            "XF86AudioPrev"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl previous\")")
          ];
        }
        {
          _args = [
            "XF86AudioStop"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl stop\")")
          ];
        }
        {
          _args = [
            "XF86AudioRaiseVolume"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+\")")
            {
              locked = true;
              repeating = true;
            }
          ];
        }
        {
          _args = [
            "XF86AudioLowerVolume"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-\")")
            {
              locked = true;
              repeating = true;
            }
          ];
        }
        {
          _args = [
            "XF86AudioMute"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")")
            { locked = true; }
          ];
        }
        {
          _args = [
            "XF86MonBrightnessUp"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl -e4 -n2 set 5%+\")")
            {
              locked = true;
              repeating = true;
            }
          ];
        }
        {
          _args = [
            "XF86MonBrightnessDown"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl -e4 -n2 set 5%-\")")
            {
              locked = true;
              repeating = true;
            }
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
}
