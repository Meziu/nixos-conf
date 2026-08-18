{ ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  security.pam.services.hyprland.enableGnomeKeyring = true;
}
