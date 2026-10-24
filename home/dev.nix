{ pkgs, lib, ... }:

let
  custom-r-studio = pkgs.rstudioWrapper.override {
    packages = with pkgs.rPackages; [ ggplot2 dplyr xts ];
  };
in
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

      custom-r-studio

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

    programs.zed-editor = {
      enable = true;

      extensions = [
        "nix"
        "git-firefly"
        "toml"
        "html1"
        "make"
        "xml"
        "qml"
        "haskell"
        "prolog"
      ];

      userSettings = {
        "cli_default_open_behavior" = "existing_window";
        "project_panel" = {
          "dock" = "left";
        };
        "outline_panel" = {
          "dock" = "left";
        };
        "collaboration_panel" = {
          "dock" = "left";
        };
        "git_panel" = {
          "dock" = "left";
        };
        "calls" = {
          "mute_on_join" = true;
        };
        "show_edit_predictions" = false;
        "ui_font_size" = 16;
        "buffer_font_size" = 16;
        "theme" = {
          "mode" = "system";
          "light" = "One Light";
          "dark" = "Ayu Dark";
        };
        "disable_ai" = true;
        languages = {
          Nix = {
            language_servers = [
              "nil"
              "!nixd"
            ];
            formatter = {
              external = {
                command = "nixfmt";
              };
            };
          };

          qml = {
            formatter = {
              external = {
                command = "qmlformat";
                arguments = [
                  "-i"
                  "{buffer_path}"
                ];
              };
            };
            binary = {
              arguments = [
                "-E"
              ];
            };
          };
        };
      };
    };
}
