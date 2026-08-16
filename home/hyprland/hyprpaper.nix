{ config, ... }:

{
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
}
