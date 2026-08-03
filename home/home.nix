{ config, lib, pkgs, ... }:
let
  kb = import ../modules/apple-aluminum-keyboard.nix;
in
{
  home.keyboard = {
    layout = kb.layout;
    variant = kb.variant;
    options = [ kb.options ]; # home.keyboard.options wants a list
  };

  wayland.windowManager.hyprland.settings.input = {
    kb_layout = kb.layout;
    kb_variant = kb.variant;
    kb_options = kb.options;
  };

  programs.kitty.enable = true;
  wayland.windowManager.hyprland.enable = true;
  # Optional, hint Electron apps to use Wayland:
  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
