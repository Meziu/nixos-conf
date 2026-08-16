{ pkgs, ... }:

{
  programs.firefox.enable = true;
  programs.git.enable = true;
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
    extraPackages = [ pkgs.jdk ];
  };

  programs.gamemode.enable = true;
  programs.java.enable = true;
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  services.flatpak.enable = true;

  environment = {
    sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
    pathsToLink = [
      "/share/nautilus-python/extensions"
    ];

    systemPackages = with pkgs; [
      vim
      kitty
      home-manager
      nautilus
      nautilus-python
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    nerd-fonts.ubuntu-mono
  ];

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
