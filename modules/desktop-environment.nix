{ ... }:

{
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  security.pam.services.gdm-password.enableGnomeKeyring = true;
  # services.desktopManager.plasma6.enable = true;

  imports = [
    ./hyprland.nix
  ];

  services.gvfs.enable = true;

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.blueman.enable = true;

  services.libinput.touchpad.naturalScrolling = true;

  services.power-profiles-daemon.enable = true;

  # Enable touchpad support (enabled by default in most desktopManagers).
  services.libinput.enable = true;
}
