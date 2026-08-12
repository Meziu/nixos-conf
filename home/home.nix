{ config, lib, pkgs, ... }:

let
  kb = import ../modules/apple-aluminum-keyboard.nix;
in
{
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
    zed-editor
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
  ];

  programs.kitty.enable = true;
  programs.discord.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "lua";

    settings = {
      config = {
        input = {
          kb_layout = kb.layout;
          kb_variant = kb.variant;
          kb_options = kb.options;
        };
      };

      monitor = {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = "auto";
      };

      bind = [
      {
        _args = [
          "SUPER + RETURN"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"kitty\")")
        ];
      }
      {
        _args = [
          "SUPER + D"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"walker\")")
        ];
      }
    ];
    };
  };

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

  home.stateVersion = "26.05";
}
