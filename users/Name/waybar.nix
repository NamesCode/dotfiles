{
  config,
  pkgs,
  ...
}:
{
  # Setup waybar
  programs.waybar = {
    enable = true;
    settings = {
      # Check https://github.com/Alexays/Waybar/wiki/Configuration for details ^^
      mainBar = {
        layer = "bottom";
        position = "top";
        output = [
          "eDP-1"
          "HDMI-A-1"
        ];
        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "sway/window"
          "mpd"
        ];
        #modules-center = [ "custom/hello-from-waybar" "custom/mymodule#with-css-id" ];
        modules-right = [
          "privacy"
          "cpu"
          "clock"
          "wireplumber"
          "network"
          "battery"
        ];

        "sway/workspaces" = {
          disable-scroll = true;
        };
        "sway/window" = {
          max-length = 20;
        };

        cpu = {
          format = "  {usage}%";
        };

        clock = {
          format = "  {:%H:%M}";
          tooltip = true;
          # Refer to https://fmt.dev/latest/syntax/#chrono-format-specifications for the format
          tooltip-format = "{:%a %d %b %Y | %Y-%m-%d}";
        };

        network = {
          format = "   {bandwidthTotalBytes} {frequency}GHz";
          format-disconnected = " ";
          interval = 5;
        };

        battery = {
          format = "{icon} {capacity}%";
          format-charging = "  {capacity}%";
          format-icons = [
            " "
            " "
            " "
            " "
            " "
          ];
          states = {
            "critical" = 15;
            "low" = 25;
            "medium" = 75;
            "full" = 100;
          };
        };

        wireplumber = {
          format-muted = "  {volume}%";
          format = "{icon} {volume}%";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          format-icons = [
            " "
            " "
          ];
        };

        # Example on how to write a custom module
        # "custom/hello-from-waybar" = {
        #   format = "hello {}";
        #   max-length = 40;
        #   interval = "once";
        #   exec = pkgs.writeShellScript "hello-from-waybar" ''
        #     echo "from within waybar"
        #   '';
        # };
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrains Mono", "Fira Code";
        color: #cdd6f4;
      }

      @keyframes blink {
        0% { opacity: 1; }
        25% { opacity: 0.85; }
        50% { opacity: 0.7; }
        75% { opacity: 0.55; }
        100% { opacity: 0.3; }
      }

      /* Waybar itself */
      window#waybar {
        background: rgba(30, 30, 46, 0.98);
      }

      tooltip {
        background: rgba(24, 24, 37, 0.98);
        border-radius: 3px;
      }

      /* CSS for the left side */
      #workspaces button {
        background: rgba(24, 24, 37, 0.98);
        padding: 0 5px;
        border-bottom: 1px solid #9399b2;
      }
      #workspaces button label {
        color: #9399b2;
      }
      #workspaces button:hover {
        box-shadow: none;
        text-shadow: none;
        transition: none;
        border-color: #cdd6f4;
      }
      #workspaces button:hover label {
        color: #cdd6f4;
      }
      #workspaces button.focused {
        border-color: #f38ba8;
      }
      #workspaces button.focused label {
        color: #f38ba8;
      }
      #workspaces button.urgent {
        border-color: #fab387;
      }
      #workspaces button.urgent label {
        color: #fab387;
      }

      #mode {
        margin: 2px 3px;
        background: #fab387;
        color: #181825;
        border-radius: 4.5px;
        font-weight: bold;
      }

      #window {
        padding-left: 3px;
      }


      /* CSS for the right side */
      #cpu, #clock, #wireplumber, #network, #battery {
        background: rgba(24, 24, 37, 0.98);
        padding: 0px 2px;
        border-bottom: 1px solid #cdd6f4;
      }

      #cpu {
        border-color: #f38ba8;
        color: #f38ba8;
      }

      /* #privacy-item {} */

      #clock {
        border-color: #fab387;
        color: #fab387;
      }

      #wireplumber {
        border-color: #f9e2af;
        color: #f9e2af;
      }

      #network {
        border-color: #89dceb;
        color: #89dceb;
      }

      #battery {
        border-color: #a6e3a1;
        color: #a6e3a1;
      }
      #battery.critical {
        border-color: #f38ba8;
        color: #f38ba8;
        animation: blink 0.5s alternate infinite;
      }
      #battery.low {
        border-color: #fab387;
        color: #fab387;
      }
      #battery.medium {
        border-color: #f9e2af;
        color: #f9e2af;
      }
      #battery.full {
        border-color: #a6e3a1;
        color: #a6e3a1;
      }
      #battery.charging {
        border-color: #a6e3a1;
        color: #a6e3a1;
        animation: blink 2s alternate infinite;
      }
    '';
  };
}
