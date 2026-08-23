{ pkgs, ... }:

let
  kb = import ./apple-aluminum-keyboard.nix;
in
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager = {
    enable = true;
  };
  networking.wireless.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.enableRedistributableFirmware = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  services.xserver.xkb = {
    layout = kb.layout;
    variant = kb.variant;
    options = kb.options;
  };

  console.keyMap = kb.consoleKeyMap;

  services.udisks2.enable = true;
  services.printing.enable = true;

  # programs.mtr.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };

  networking.firewall.enable = false;

  system.stateVersion = "26.05";
}
