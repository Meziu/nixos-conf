{ pkgs, ... }:

{
  home.packages = with pkgs; with python314Packages; [
    nil # Nix LSP
    nixfmt
    rustup
    gcc
    swi-prolog
    haskellPackages.ghc
    haskellPackages.cabal-install

    # Utilities
    perf

    # Python garbage
    python
    numpy
    matplotlib
    pillow
    scikit-learn
    scipy
    torch
  ];
}
