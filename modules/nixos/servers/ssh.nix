{
  lib,
  config,
  pkgs,
  ...
}:
{
  services.openssh = {
    enable = true;

    # We use the default port since using a different doesn't do much really
    ports = [ 22 ];

    # Enables sftp
    allowSFTP = true;

    settings = {
      PasswordAuthentication = false;
      AllowGroups = [ "allowed-ssh" ];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  services.fail2ban.enable = true;
}
