{
  pkgs,
  ...
}:

let
  kb = import ../modules/apple-aluminum-keyboard.nix;
in
{
  imports = [
    ./programs.nix
    ./hyprland
  ];

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
    networkmanagerapplet

    # Programming
    nil # Nix LSP
    nixfmt

    # Hyprland software
    hyprlock
    hyprshot
    libnotify
  ];

  home.stateVersion = "26.05";
}
