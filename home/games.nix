{ pkgs, ... }:

{
  home.packages = with pkgs; [
    prismlauncher
    protonup-ng
    eden
    osu-lazer-bin
    heroic
    itch
  ];
}
