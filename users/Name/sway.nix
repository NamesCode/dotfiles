{
  config,
  pkgs,
  ...
}:
let
  # Modifier key
  modifier = "Mod4";
  # Keyboard backlight device
  keyboard = "kbd_backlight";
in
{
  # Configure Sway
  wayland.windowManager.sway = {
    enable = true;
    package = null;

    config = {
      # Sets the wallpaper for all outputs
      output."*".bg = "${config.vars.wallpaper} fill";

      # Set fonts
      fonts.names = [ "${config.vars.mainFont}" ];

      # Opens in workspace 1
      defaultWorkspace = "workspace number 1";

      # Set theme
      colors = {
        background = "#ffffff00"; # Makes the window background transparent
        focused = {
          background = "#1e1e2e";
          border = "#f38ba8";
          childBorder = "#f38ba8";
          indicator = "#f38ba8";
          text = "#cdd6f4";
        };
        focusedInactive = {
          background = "#1e1e2e";
          border = "#f38ba8";
          childBorder = "#f38ba8";
          indicator = "#f38ba8";
          text = "#cdd6f4";
        };
        unfocused = {
          background = "#181825";
          border = "#eba0ac";
          childBorder = "#eba0ac";
          indicator = "#eba0ac";
          text = "#bac2de";
        };
        urgent = {
          background = "#1e1e2e";
          border = "#fab387";
          childBorder = "#fab387";
          indicator = "#fab387";
          text = "#cdd6f4";
        };
      };

      # Window theming
      window = {
        border = 2;
        titlebar = false;
      };

      # Set gap size
      gaps.inner = 3;

      # Set the bar
      bars = [
        {
          command = "${pkgs.waybar}/bin/waybar";
          position = "top";
        }
      ];

      # Define the keybindings
      keybindings = {
        # General binds
        "${modifier}+q" = "kill";
        "${modifier}+d" = "exec $(${pkgs.tofi}/bin/tofi-run)";
        "${modifier}+r" = "mode resize";

        "${modifier}+Shift+r" = "reload";
        "${modifier}+Shift+q" = "exec swaynag -t warning -m 'Are you sure you want to exit Sway?' -b 'Yes, exit sway' 'swaymsg exit'";

        # Utils
        "${modifier}+Shift+s" = "exec ${config.xdg.dataHome}/scripts/screenshot.sh";

        "${modifier}+F1" = "exec brightnessctl s 10-";
        "${modifier}+Shift+F1" = "exec brightnessctl s 0%";
        "${modifier}+F2" = "exec brightnessctl s 10+";
        "${modifier}+Shift+F2" = "exec brightnessctl s 100%";
        "${modifier}+Alt+F1" = "exec brightnessctl -d ${keyboard} s 10-";
        "${modifier}+Alt+Shift+F1" = "exec brightnessctl -d ${keyboard} s 0%";
        "${modifier}+Alt+F2" = "exec brightnessctl -d ${keyboard} s 10+";
        "${modifier}+Alt+Shift+F2" = "exec brightnessctl -d ${keyboard} s 100%";
        "${modifier}+Ctrl+F1" = "output * dpms off";
        "${modifier}+Ctrl+F2" = "output * dpms on";

        "${modifier}+F10" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "${modifier}+F11" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "${modifier}+F12" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";

        # Applications
        "${modifier}+Alt+t" = "exec ${pkgs.foot}/bin/foot";
        "${modifier}+Alt+f" = "exec firefox";
        "${modifier}+Alt+v" = "exec vlc";

        # Window navigation
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        # Layout
        "${modifier}+b" = "splith";
        "${modifier}+v" = "splitv";
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+a" = "focus parent";

        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+space" = "focus mode_toggle";

        "${modifier}+Shift+Tab" = "move scratchpad";
        "${modifier}+Tab" = "scratchpad show";

        # Workspace
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";
      };

      # Stop sway from focusing every window you hover
      focus.followMouse = false;

      # Start programs on Sway startup
      startup = [
        # Since we don't use SystemD for Sway, we must exec Swayidle through Sway
        {
          command = "${pkgs.swayidle}/bin/swayidle timeout 120 'swaylock -f' timeout 240 'systemctl suspend' before-sleep 'swaylock -f' lock 'swaylock -f'";
        }
        { command = "${pkgs.mako}/bin/mako --config ${config.xdg.configHome}/mako/config"; }
        # Apps
        { command = "firefox"; }
        { command = "foot"; }
      ];
    };

    # I got no clue what this does
    wrapperFeatures = {
      gtk = true;
    };
  };

  # Configure swaylock
  programs.swaylock = {
    enable = true;
    settings = {
      color = "#1e1e2e";
      image = "${config.vars.wallpaper}";
      scaling = "fill";
      font = "${config.vars.mainFont}";
      font-size = 35;
      inside-color = "#1e1e2ebb";
      inside-clear-color = "#1e1e2ebb";
      inside-caps-lock-color = "#1e1e2ebb";
      inside-ver-color = "#1e1e2ebb";
      inside-wrong-color = "#1e1e2ebb";
      bs-hl-color = "#eba0ac";
      key-hl-color = "#fab387";
      layout-bg-color = "#1e1e2e";
      line-color = "#11111b";
      line-clear-color = "#11111b";
      line-caps-lock-color = "#11111b";
      line-ver-color = "#11111b";
      line-wrong-color = "#11111b";
      ring-color = "#1e1e2e";
      ring-clear-color = "#f9e2af";
      ring-ver-color = "#89b4fa";
      ring-wrong-color = "#f38ba8";
      separator-color = "#313244";
      text-color = "#cdd6f4";
      text-clear-color = "#cdd6f4";
      text-caps-lock-color = "#cdd6f4";
      text-ver-color = "#cdd6f4";
      text-wrong-color = "#cdd6f4";
      show-failed-attempts = true;
    };
  };

  home.packages = with pkgs; [
    # Screenshots
    grim
    slurp

    # Clipboard
    wl-clipboard

    # Handle idling
    swayidle
  ];
}
