{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."andreaciliberti" = {
    isNormalUser = true;
    description = "Andrea Ciliberti";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
  };
}
