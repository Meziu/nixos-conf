{
  pkgs,
  ...
}:

{
  #services.displayManager.gdm.enable = true;
  #security.pam.services.gdm-password.enableGnomeKeyring = true;
  /*
    services.displayManager.ly = {
      enable = true;

      settings = {
        animation = "dur_file";
        full_color = true;
        dur_file_path = "${inputs.ly-community}/animations/dur/blackhole-smooth-240x67.dur";
      };
    };
    security.pam.services.ly.enableGnomeKeyring = true;
  */

  environment.systemPackages = with pkgs; [
    bibata-cursors

    qt6.qt5compat
    qt6.qtmultimedia
  ];

  services.displayManager.sddm = {
    enable = true;
    setupScript = ''
      ${pkgs.xrdb}/bin/xrdb -merge - <<EOF
      Xcursor.theme: Bibata-Modern-Classic
      EOF
    '';
    settings = {
      Theme = {
        CursorTheme = "Bibata-Modern-Classic";
        CursorSize = 24;
      };
    };
  };
  security.pam.services.sddm.enableGnomeKeyring = true;
  services.xserver.enable = true;
  programs.qylock = {
    enable = true;
    theme = "field";
    sddm.enable = true;
    quickshell.enable = true;
  };

  environment.sessionVariables = {
    QML2_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.qt6.qtmultimedia}/lib/qt-6/qml";
  };

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
