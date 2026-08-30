{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./swaync.nix
    ./session.nix
    ./hyprpaper.nix
    ./launcher.nix
  ];

  home.packages = with pkgs; [
    brightnessctl

    libnotify

    hyprshutdown
    hyprpicker

    qt6.qtwayland
    qt6.qtmultimedia
    qt6.qt5compat
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
  services.pipewire.wireplumber.enable = true;
  services.network-manager-applet.enable = true;

  /*
  services.kanshi = {
    enable = true;

    settings =
      let
        mainMonitor = "LG Electronics E2250 004MAJMFW724";
        reloadExec = [
          "systemctl --user restart waybar.service"
          "hyprctl reload"
        ];
      in
      [
        {
          profile.name = "docked";
          profile.outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1200@60Hz";
              status = "disable";
              scale = 1.0;
            }
            {
              criteria = mainMonitor;
              mode = "1920x1080@60Hz";
              status = "enable";
              scale = 1.0;
            }
          ];
          profile.exec = reloadExec;
        }

        {
          profile.name = "undocked";
          profile.outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1200@60Hz";
              status = "enable";
              scale = 1.0;
            }
          ];
          profile.exec = reloadExec;
        }
      ];
  };
  */

  programs.hyprshot.enable = true;

  programs.quickshell = {
    enable = true;
    systemd.enable = true;

    configs = {
      qs-hyprview = inputs.qs-hyprview;
    };
    activeConfig = "qs-hyprview";
  };

  # Optional, hint Electron apps to use Wayland:
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
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
}
