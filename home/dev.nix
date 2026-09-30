{ pkgs, lib, ... }:

{
  home.packages =
    (with pkgs; [
      nil
      nixfmt
      rustup
      pkg-config
      gcc
      swi-prolog
      haskellPackages.ghc
      haskellPackages.cabal-install

      # Utilities
      perf
      graphviz
    ])
    ++ (with pkgs.python314Packages; [
      python
      numpy
      matplotlib
      pillow
      scikit-learn
      scipy
      torch
    ]);

    home.sessionVariables.JAVA_TOOL_OPTIONS = lib.concatStringsSep " " [
      "-Dawt.useSystemAAFontSettings=on"
      "-Dswing.aatext=true"
      "-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
    ];
}
