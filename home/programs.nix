{ pkgs, ... }:

{
  imports = [
    ./tex.nix
    ./games.nix
  ];

  home.packages = with pkgs; [
    kdePackages.kate
    kdePackages.filelight
    vlc
    #audacity
    cheese
    gimp
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
    obs-studio
    rclone
    openssh
    gnupg
    pavucontrol
    inkscape
    pinta
    shotcut
  ];

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      background_opacity = 0.6;
      remember_window_size = false;
    };
  };
  programs.discord.enable = true;

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
