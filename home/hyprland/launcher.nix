{ config, ... }:

{
  # Walker
  services.elephant.enable = true;
  services.walker = {
    enable = true;
    enableElephantIntegration = config.services.elephant.enable;
    systemd.enable = true;

    theme.style = ''
      @define-color window_bg_color rgba(30, 30, 46, 0.82);
      @define-color surface_color #313244;
      @define-color accent_color #fab387;
      @define-color text_color #f5e0dc;
      @define-color subtext_color #a6adc8;
      @define-color error_bg_color #f38ba8;
      @define-color error_fg_color #1e1e2e;

      * {
        all: unset;
        font-family: "Inter", "SF Pro Display", sans-serif;
      }

      /* Floating window itself — the glass card */
      .box-wrapper {
        background: @window_bg_color;
        border: 1px solid alpha(@accent_color, 0.25);
        border-radius: 28px;
        padding: 18px;
        box-shadow:
          0 25px 50px rgba(0, 0, 0, 0.45),
          inset 0 1px 0 rgba(255, 255, 255, 0.05);
      }

      .normal-icons { -gtk-icon-size: 20px; }
      .large-icons  { -gtk-icon-size: 34px; }
      scrollbar     { opacity: 0; }

      /* Search bar — rounded pill, same language as the waybar zones */
      .search-container {
        background: alpha(@surface_color, 0.55);
        border: 1px solid alpha(@accent_color, 0.2);
        border-radius: 20px;
        padding: 2px 6px;
      }
      .input {
        background: transparent;
        color: @text_color;
        caret-color: @accent_color;
        font-size: 17px;
        font-weight: 500;
        padding: 12px 14px;
      }
      .input placeholder { color: alpha(@text_color, 0.4); }
      .input selection   { background: alpha(@accent_color, 0.35); }

      .placeholder, .elephant-hint, .preview-box { color: @subtext_color; }

      /* Results list */
      .list { color: @text_color; }

      .item-box {
        border-radius: 16px;
        padding: 10px 12px;
        margin: 2px 0;
        transition: background-color 120ms ease;
      }
      child:selected .item-box,
      row:selected .item-box {
        background: linear-gradient(135deg, alpha(@accent_color, 0.28), alpha(@accent_color, 0.14));
        border: 1px solid alpha(@accent_color, 0.35);
      }

      .item-quick-activation {
        background: alpha(@accent_color, 0.18);
        color: @accent_color;
        border-radius: 8px;
        padding: 2px 6px;
        font-size: 11px;
        font-weight: 700;
      }

      .item-text     { color: @text_color; font-weight: 600; }
      .item-subtext  { color: @subtext_color; font-size: 12px; opacity: 0.8; }
      .providerlist .item-subtext { opacity: 0.9; }
      .item-image-text { font-size: 26px; }

      /* Preview pane */
      .preview {
        background: alpha(@surface_color, 0.4);
        border: 1px solid alpha(@accent_color, 0.2);
        border-radius: 16px;
        color: @text_color;
      }
      .preview .large-icons { -gtk-icon-size: 64px; }

      /* Calculator / symbols / todo / bluetooth providers */
      .calc .item-text { font-size: 26px; color: @accent_color; font-weight: 700; }
      .symbols .item-image { font-size: 24px; }
      .todo.done .item-text-box { opacity: 0.35; }
      .todo.urgent { color: @error_bg_color; font-size: 24px; }
      .todo.active { font-weight: bold; color: @accent_color; }
      .bluetooth.disconnected { opacity: 0.45; }

      /* Keybind hints footer */
      .keybinds {
        padding-top: 12px;
        margin-top: 10px;
        border-top: 1px solid alpha(@accent_color, 0.15);
        font-size: 11px;
        color: @subtext_color;
      }
      .keybind-button { opacity: 0.5; }
      .keybind-button:hover { opacity: 0.85; }
      .keybind-bind { text-transform: lowercase; opacity: 0.4; }
      .keybind-label {
        padding: 2px 6px;
        border-radius: 6px;
        border: 1px solid alpha(@accent_color, 0.4);
        color: @accent_color;
        background: alpha(@accent_color, 0.1);
      }

      .error {
        padding: 12px;
        border-radius: 12px;
        background: alpha(@error_bg_color, 0.9);
        color: @error_fg_color;
      }

      :not(.calc).current { font-style: italic; }
      .preview-content.archlinuxpkgs,
      .preview-content.dnfpackages { font-family: monospace; }
    '';
  };
}
