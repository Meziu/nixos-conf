{ pkgs, ... }:

{
  imports = [
    ./tex.nix
  ];

  home.packages = with pkgs; [
    kdePackages.kate
    kdePackages.filelight
    vlc
    audacity
    cheese
    gimp
    prismlauncher
    spotify
    telegram-desktop
    deluge
    obsidian
    chromium
    libreoffice
    thunderbird
    ente-auth
    eog # gnome image viewer
    papers # gnome document viewer
    gnome-system-monitor
    gnome-clocks
    gparted
    gnome-disk-utility
    file-roller # gnome unarchiver
    popsicle
    deja-dup
    protonup-ng
    obs-studio
    rclone
    openssh
    gnupg
    pavucontrol
    inkscape
  ];

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      background_opacity = 0.6;
    };
  };
  programs.discord.enable = true;

  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "git-firefly"
      "toml"
      "html1"
      "make"
      "xml"
      "qml"
      "haskell"
      "prolog"
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

        qml = {
          formatter = {
            external = {
              command = "qmlformat";
              arguments = [
                "-i"
                "{buffer_path}"
              ];
            };
          };
          binary = {
            arguments = [
              "-E"
            ];
          };
        };
      };
    };
  };

  fonts.fontconfig = {
    enable = true;

    configFile = {
      song-title-fallback = {
        enable = true;
        priority = 50;
        text = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
          <fontconfig>
            <match target="pattern">
              <test name="family" compare="eq" qual="any">
                <string>ITC Serif Gothic Extra</string>
              </test>
              <edit name="family" mode="append" binding="strong">
                <string>Noto Sans Malayalam</string>
              </edit>
              <edit name="family" mode="append" binding="strong">
                <string>Symbols Nerd Font</string>
              </edit>
              <edit name="family" mode="append" binding="strong">
                <string>Noto Color Emoji</string>
              </edit>
            </match>
          </fontconfig>
        '';
      };
    };
  };
}
