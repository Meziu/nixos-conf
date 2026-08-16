# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/users.nix
    ../../modules/common-settings.nix
    ../../modules/desktop-environment.nix
    ../../modules/fingerprint-thinkpad-e14.nix
    ../../modules/intel-graphics-drivers.nix
    ../../modules/system-apps-desktop.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.systemd-boot.configurationLimit = 10;

  networking.hostName = "nixos-thinkbook"; # Define your hostname.
}
