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
