{
  pkgs,
  ...
}:

let
  kb = import ../modules/apple-aluminum-keyboard.nix;
in
{
  imports = [
    ./hyprland
    ./programs.nix
    ./dev.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "andreaciliberti";
  home.homeDirectory = "/home/andreaciliberti";

  home.keyboard = {
    layout = kb.layout;
    variant = kb.variant;
    options = [ kb.options ]; # home.keyboard.options wants a list
  };

  xdg.portal.enable = true;

  home.packages = with pkgs; [
    networkmanagerapplet

    # Hyprland software
    hyprlock
    hyprshot
    libnotify
  ];

  home.stateVersion = "26.05";
}
