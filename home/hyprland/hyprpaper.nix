{ config, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = [
        "${config.home.homeDirectory}/Pictures/Wallpapers/OuterWilds/Fireplace.png"
      ];
      wallpaper = [
        {
          monitor = "";
          path = "${config.home.homeDirectory}/Pictures/Wallpapers/OuterWilds/Fireplace.png";
        }
      ];
    };
  };
}
