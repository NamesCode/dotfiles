{ config, pkgs, ... }:
{
  programs.steam = {
    enable = true;

    # Gamescope config
    extraPackages = with pkgs; [ gamescope ];
    gamescopeSession = {
      enable = true;
    };

    # Translate X11 inputs to Wayland
    extest.enable = true;

    # Access winetricks easily through proton
    protontricks.enable = true;
  };
}
