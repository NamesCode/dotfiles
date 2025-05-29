{
  config,
  pkgs,
  lib,
  ...
}:
let
  modifier = "cmd";
  scriptFolder = "~/.xdg/usr/share/scripts";
  appleScript = command: "osascript -e '${command}'";
  yabai = { domain, command }: "yabai -m ${domain} ${command}";
in
{
  services = {
    yabai = {
      enable = true;
      enableScriptingAddition = true;

      config = {
        focus_follows_mouse = "autofocus";

        # Window modifications
        window_shadow = "float";
        window_opacity = "on";
        layout = "bsp";

        # Window padding
        top_padding = 10;
        bottom_padding = 10;
        left_padding = 10;
        right_padding = 10;
        window_gap = 10;
      };

      extraConfig = ''
        # Change style based off which app is focused
        ${yabai {
          domain = "signal";
          command = "--add event=window_focused action=\"borders style=square\" app=Alacritty";
        }}

        ${yabai {
          domain = "signal";
          command = "--add event=window_focused action=\"borders style=round\" app!=Alacritty";
        }}

        # Funky sfx :3
        ${yabai {
          domain = "signal";
          command = "--add event=space_destroyed action=\"afplay ${../../modules/misc/audio/static.flac} &\"";
        }}
      '';
    };

    skhd = {
      enable = true;
      skhdConfig = ''
        # Modes
        :: default : borders active_color=0xFFF38BA8 inactive_color=0xFFEBA0AC
        :: resize : borders active_color=0xFFF38BA8 inactive_color=0xFFEBA0AC

        # General binds
        # ${modifier}-d : ${appleScript "tell application System Events to keystroke \"space\" using {command down}"} 

        # Utils
        ${modifier}+shift-s : ${scriptFolder}/screenshot.sh 
        ${modifier}+alt-l : pgrep caffeinate && pkill caffeinate || caffeinate -dimsu &

        # Applications
        ${modifier}+alt-t : open -a alacritty
        ${modifier}+alt-f : open -a firefox
        ${modifier}+alt-v : open -a vlc && open ~/media/music

        # Window navigation

        ## Jump to certain window
        ${modifier}+ctrl-h : ${
          yabai {
            domain = "window";
            command = "--focus west";
          }
        }
        ${modifier}+ctrl-j : ${
          yabai {
            domain = "window";
            command = "--focus south";
          }
        }
        ${modifier}+ctrl-k : ${
          yabai {
            domain = "window";
            command = "--focus north";
          }
        }
        ${modifier}+ctrl-l : ${
          yabai {
            domain = "window";
            command = "--focus east";
          }
        }

        ## Mirror workspace
        ${modifier}+shift-m : ${
          yabai {
            domain = "space";
            command = "--mirror x-axis";
          }
        }

        ## Scoot window
        ${modifier}+shift-h : ${
          yabai {
            domain = "window";
            command = "--swap west";
          }
        }
        ${modifier}+shift-j : ${
          yabai {
            domain = "window";
            command = "--swap south";
          }
        }
        ${modifier}+shift-k : ${
          yabai {
            domain = "window";
            command = "--swap north";
          }
        }
        ${modifier}+shift-l : ${
          yabai {
            domain = "window";
            command = "--swap east";
          }
        }

        ## Grow window
        ${modifier}+alt+shift-h : ${
          yabai {
            domain = "window";
            command = "--resize right:-5:0";
          }
        } \
        ${
          yabai {
            domain = "window";
            command = "--resize left:-5:0";
          }
        } 

        ${modifier}+alt+shift-j : ${
          yabai {
            domain = "window";
            command = "--resize top:0:5";
          }
        } \
        ${
          yabai {
            domain = "window";
            command = "--resize bottom:0:5";
          }
        } 

        ${modifier}+alt+shift-k : ${
          yabai {
            domain = "window";
            command = "--resize top:0:-5";
          }
        } \
        ${
          yabai {
            domain = "window";
            command = "--resize bottom:0:-5";
          }
        } 

        ${modifier}+alt+shift-l : ${
          yabai {
            domain = "window";
            command = "--resize right:5:0";
          }
        } \
        ${
          yabai {
            domain = "window";
            command = "--resize left:5:0";
          }
        } 


        # Layout
        ${modifier}+shift-space : ${
          yabai {
            domain = "window";
            command = "--toggle float";
          }
        }

        # Workspace
        ${modifier}+alt-n : ${
          yabai {
            domain = "space";
            command = "--create";
          }
        }
        ${modifier}+alt-q : ${
          yabai {
            domain = "space";
            command = "--destroy last";
          }
        }

        ## Jump to specific workspace
        ${modifier}-1 : ${
          yabai {
            domain = "space";
            command = "--focus 1";
          }
        }
        ${modifier}-2 : ${
          yabai {
            domain = "space";
            command = "--focus 2";
          }
        }
        ${modifier}-3 : ${
          yabai {
            domain = "space";
            command = "--focus 3";
          }
        }
        ${modifier}-4 : ${
          yabai {
            domain = "space";
            command = "--focus 4";
          }
        }
        ${modifier}-5 : ${
          yabai {
            domain = "space";
            command = "--focus 5";
          }
        }
        ${modifier}-6 : ${
          yabai {
            domain = "space";
            command = "--focus 6";
          }
        }
        ${modifier}-7 : ${
          yabai {
            domain = "space";
            command = "--focus 7";
          }
        }
        ${modifier}-8 : ${
          yabai {
            domain = "space";
            command = "--focus 8";
          }
        }
        ${modifier}-9 : ${
          yabai {
            domain = "space";
            command = "--focus 9";
          }
        }
        ${modifier}-0 : ${
          yabai {
            domain = "space";
            command = "--focus 10";
          }
        }

        ## Move to specific workspace
        ${modifier}+shift-1 : ${
          yabai {
            domain = "window";
            command = "--space 1";
          }
        } 
        ${modifier}+shift-2 : ${
          yabai {
            domain = "window";
            command = "--space 2";
          }
        } 
        ${modifier}+shift-3 : ${
          yabai {
            domain = "window";
            command = "--space 3";
          }
        } 
        ${modifier}+shift-4 : ${
          yabai {
            domain = "window";
            command = "--space 4";
          }
        } 
        ${modifier}+shift-5 : ${
          yabai {
            domain = "window";
            command = "--space 5";
          }
        } 
        ${modifier}+shift-6 : ${
          yabai {
            domain = "window";
            command = "--space 6";
          }
        } 
        ${modifier}+shift-7 : ${
          yabai {
            domain = "window";
            command = "--space 7";
          }
        } 
        ${modifier}+shift-8 : ${
          yabai {
            domain = "window";
            command = "--space 8";
          }
        } 
        ${modifier}+shift-9 : ${
          yabai {
            domain = "window";
            command = "--space 9";
          }
        } 
        ${modifier}+shift-0 : ${
          yabai {
            domain = "window";
            command = "--space 10";
          }
        }
      '';
    };

    jankyborders = {
      enable = true;
      width = 6.0;
      style = "round";

      # Follows 0xAARRGGBB format
      active_color = "0xFFF38BA8";
      inactive_color = "0xFFEBA0AC";
    };
  };
}
