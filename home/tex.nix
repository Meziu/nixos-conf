{ pkgs, ... }:

{
  home.packages = with pkgs; [
    texstudio

    (texliveMedium.withPackages (
      ps: with ps; [
        hyperref
        amsmath
        collection-langitalian
        collection-mathscience
      ]
    ))
  ];
}
