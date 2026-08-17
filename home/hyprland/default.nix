{
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
    hyprlock
    libnotify

    qt6.qtwayland
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

  services.network-manager-applet.enable = true;

  programs.hyprshot.enable = true;

  programs.quickshell = {
    enable = false;
    systemd.enable = false;
  };
  systemd.user.services.quickshell.Service.Environment = [
    "QML2_IMPORT_PATH=${pkgs.qt6.qt5compat}/lib/qt-6/qml"
  ];
  home.sessionVariables.QML2_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml";

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
}
