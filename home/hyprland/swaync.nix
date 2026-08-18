{ ... }:

{
  services.swaync = {
    enable = true;

    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      widgets = [
        "title"
        "dnd"
        "mpris"
        "notifications"
      ];
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      hide-on-clear = false;
      fit-to-screen = false;
      control-center-height = -1;
      control-center-width = 380;
      control-center-margin-top = 8;
      control-center-margin-right = 8;
      control-center-margin-bottom = 8;
      control-center-margin-left = 0;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      widget-config = {
        notifications = {
          vexpand = false;
        };
      };
    };

    style = ''
      * {
        font-family: "Symbols Nerd Font", "UbuntuMono Nerd Font";
        font-size: 18px;
        font-weight: bold;
        min-height: 0;
      }

      /* ============================================================
         Top-level windows stay fully transparent so only the pills
         below are visible, same trick as window#waybar
         ============================================================ */
      window.control-center,
      .floating-notifications.background,
      .blank-window {
        background: transparent;
      }

      /* ============================================================
         Control center — the big glass pill that holds everything.
         Same gradient/border/shadow recipe as the waybar islands.
         ============================================================ */
      .control-center {
        background: linear-gradient(135deg,
                      rgba(30, 30, 46, 0.90),
                      rgba(30, 30, 46, 0.97));
        border: 1px solid rgba(250, 179, 135, 0.28);
        border-radius: 18px;
        padding: 6px;
        box-shadow:
          0 4px 10px rgba(0, 0, 0, 0.35),
          inset 0 1px 0 rgba(255, 255, 255, 0.06);
      }

      .control-center-list {
        background: transparent;
        padding: 2px 4px;
      }

      .control-center-list-placeholder {
        color: #6c7086;
        opacity: 0.7;
        font-weight: 500;
      }

      /* ============================================================
         Scrollbar — thin glass thumb, only appears once the pending
         notifications actually overflow control-center-height
         ============================================================ */
      scrollbar {
        background: transparent;
        border: none;
      }
      scrollbar slider {
        background-color: rgba(250, 179, 135, 0.35);
        border-radius: 10px;
        min-width: 6px;
        min-height: 6px;
      }
      scrollbar slider:hover {
        background-color: rgba(250, 179, 135, 0.55);
      }

      /* ============================================================
         Title widget — "Notifications" heading + Clear All button
         ============================================================ */
      .widget-title {
        margin: 6px 10px 2px 10px;
        padding: 4px 8px;
      }
      .widget-title > label {
        font-size: 16px;
        font-weight: 700;
        color: #fab387;
      }
      .widget-title > button {
        padding: 4px 12px;
        border-radius: 12px;
        background: linear-gradient(135deg,
                      rgba(250, 179, 135, 0.16),
                      rgba(250, 179, 135, 0.05));
        border: 1px solid rgba(250, 179, 135, 0.28);
        color: #f5e0dc;
        font-size: 13px;
        font-weight: 600;
        box-shadow: none;
        transition: background-color 0.2s ease;
      }
      .widget-title > button:hover {
        background-color: rgba(250, 179, 135, 0.20);
      }

      /* ============================================================
         Do Not Disturb toggle
         ============================================================ */
      .widget-dnd {
        margin: 2px 14px 6px 14px;
      }
      .widget-dnd > label {
        color: #f5e0dc;
        font-size: 13px;
        font-weight: 600;
      }
      .widget-dnd > switch {
        border-radius: 30px;
        background: rgba(255, 255, 255, 0.08);
        border: 1px solid rgba(250, 179, 135, 0.2);
        background-image: none;
        box-shadow: none;
      }
      .widget-dnd > switch:checked {
        background-color: #fab387;
        border-color: #fab387;
      }
      .widget-dnd > switch slider {
        background: #1e1e2e;
        border-radius: 100%;
      }

      /* ============================================================
         Plain label widget
         ============================================================ */
      .widget-label {
        margin: 4px 14px;
      }
      .widget-label > label {
        color: #cdd6f4;
        font-size: 13px;
      }

      /* ============================================================
         Mpris — media player card, same recipe as a notification
         ============================================================ */
      .widget-mpris {
        margin: 6px 10px;
      }
      .widget-mpris-player {
        background: linear-gradient(135deg,
                      rgba(250, 179, 135, 0.14),
                      rgba(250, 179, 135, 0.04));
        border: 1px solid rgba(250, 179, 135, 0.22);
        border-radius: 14px;
        padding: 10px;
        box-shadow:
          0 4px 10px rgba(0, 0, 0, 0.30),
          inset 0 1px 0 rgba(255, 255, 255, 0.05);
      }
      .widget-mpris-title {
        color: #f5e0dc;
        font-weight: 700;
        font-size: 14px;
      }
      .widget-mpris-subtitle {
        color: #cdd6f4;
        font-size: 12px;
        opacity: 0.8;
      }
      .widget-mpris-player > button,
      .widget-mpris-player > box > button {
        background: rgba(250, 179, 135, 0.12);
        border-radius: 10px;
        color: #f5e0dc;
      }
      .widget-mpris-player > button:hover,
      .widget-mpris-player > box > button:hover {
        background: rgba(250, 179, 135, 0.22);
      }

      /* ============================================================
         Quick action button grid
         ============================================================ */
      .widget-buttons-grid {
        margin: 6px 10px;
      }
      .widget-buttons-grid > flowbox > flowboxchild > button {
        background: linear-gradient(135deg,
                      rgba(250, 179, 135, 0.14),
                      rgba(250, 179, 135, 0.04));
        border: 1px solid rgba(250, 179, 135, 0.22);
        border-radius: 14px;
        color: #f5e0dc;
        padding: 8px;
        transition: background-color 0.2s ease;
      }
      .widget-buttons-grid > flowbox > flowboxchild > button:hover {
        background-color: rgba(250, 179, 135, 0.2);
      }
      .widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked {
        background: #fab387;
        color: #1e1e2e;
        font-weight: 700;
      }

      /* ============================================================
         Volume / backlight sliders
         ============================================================ */
      .widget-volume,
      .widget-backlight {
        margin: 4px 14px;
        color: #f5e0dc;
      }
      .widget-volume > box > slider,
      .widget-backlight > box > slider {
        background: #fab387;
        border-radius: 100%;
        min-width: 14px;
        min-height: 14px;
      }
      .widget-volume > box > trough,
      .widget-backlight > box > trough {
        background: rgba(255, 255, 255, 0.08);
        border-radius: 10px;
        min-height: 6px;
      }
      .widget-volume > box > trough > highlight,
      .widget-backlight > box > trough > highlight {
        background: #fab387;
        border-radius: 10px;
      }

      /* ============================================================
         Inhibitors widget
         ============================================================ */
      .widget-inhibitors {
        margin: 4px 14px;
      }
      .widget-inhibitors > box > button {
        background: rgba(250, 179, 135, 0.12);
        border-radius: 12px;
        color: #f5e0dc;
      }
      .widget-inhibitors > box > button:hover {
        background: rgba(250, 179, 135, 0.22);
      }

      /* ============================================================
         Individual notifications — pill cards. Same classes are used
         inside the control center list and for floating popups, so
         one block styles both.
         ============================================================ */
      .notification-row {
        outline: none;
        margin: 5px 8px;
        padding: 0;
      }

      .notification-row:focus,
      .notification-row:hover {
        background: transparent;
      }

      .notification {
        background: transparent;
        border-radius: 14px;
        padding: 0;
      }

      .notification-content {
        background: linear-gradient(135deg,
                      rgba(250, 179, 135, 0.16),
                      rgba(250, 179, 135, 0.05)),
                    rgba(30, 30, 46, 0.90);
        border: 1px solid rgba(250, 179, 135, 0.22);
        border-radius: 14px;
        padding: 10px 12px;
        box-shadow:
          0 4px 10px rgba(0, 0, 0, 0.30),
          inset 0 1px 0 rgba(255, 255, 255, 0.05);
        transition: background-color 0.2s ease, border-color 0.2s ease;
      }

      .notification-row:hover .notification-content {
        background: linear-gradient(135deg,
                      rgba(250, 179, 135, 0.22),
                      rgba(250, 179, 135, 0.08)),
                    rgba(30, 30, 46, 0.94);
        border-color: rgba(250, 179, 135, 0.4);
      }

      /* Critical notifications pulse, same language as #battery.critical */
      .notification.critical .notification-content {
        border-color: rgba(243, 139, 168, 0.55);
        animation: nc-blink 1.4s infinite alternate;
      }
      @keyframes nc-blink {
        to { border-color: rgba(243, 139, 168, 0.9); }
      }

      .notification-default-action {
        padding: 0;
        background: transparent;
        border-radius: 14px;
      }

      .notification-action {
        padding: 6px 10px;
        margin: 6px 4px 0 4px;
        background: linear-gradient(135deg,
                      rgba(250, 179, 135, 0.14),
                      rgba(250, 179, 135, 0.04)),
                    rgba(30, 30, 46, 0.85);
        border: 1px solid rgba(250, 179, 135, 0.20);
        border-radius: 10px;
        color: #f5e0dc;
        font-size: 12px;
        font-weight: 600;
        transition: background-color 0.2s ease;
      }
      .notification-action:hover {
        background: rgba(250, 179, 135, 0.22);
      }

      .close-button {
        background: rgba(250, 179, 135, 0.14);
        color: #f5e0dc;
        border-radius: 100%;
        min-width: 20px;
        min-height: 20px;
        padding: 0;
        box-shadow: none;
        text-shadow: none;
      }
      .close-button:hover {
        background: rgba(250, 179, 135, 0.30);
      }

      .notification-icon,
      .image {
        border-radius: 10px;
      }

      .body-image {
        margin-top: 6px;
        border-radius: 10px;
      }

      .summary {
        color: #f5e0dc;
        font-weight: 700;
        font-size: 14px;
        text-shadow: none;
        background: transparent;
        .body {
          wrap: true;
        }
      }

      .time {
        color: #6c7086;
        font-size: 11px;
        text-shadow: none;
        background: transparent;
      }

      .body {
        color: #cdd6f4;
        font-size: 12px;
        font-weight: 500;
        text-shadow: none;
        background: transparent;
        opacity: 0.9;
      }

      .app-name {
        color: #fab387;
        font-size: 11px;
        font-weight: 800;
      }

      .progress-bar {
        background: rgba(255, 255, 255, 0.08);
        border-radius: 10px;
        min-height: 4px;
      }
      .progress-bar-value {
        background: #fab387;
        border-radius: 10px;
      }

      /* ============================================================
         Tooltips — same glassy language as waybar
         ============================================================ */
      tooltip {
        background: rgba(30, 30, 46, 0.92);
        border: 1px solid rgba(250, 179, 135, 0.35);
        border-radius: 12px;
      }
      tooltip label {
        color: #cdd6f4;
        padding: 6px 10px;
        font-size: 13px;
      }
    '';
  };
}
