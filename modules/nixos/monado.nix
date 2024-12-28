{ config, pkgs, ... }:
{
  services = {
    # Configure monado
    monado = {
      enable = true;
      highPriority = true;
      # defaultRuntime = true;
    };

    # Configure WiVRn
    wivrn = {
      enable = true;
      defaultRuntime = true;
      openFirewall = true;
      autoStart = true;
    };
  };
}
