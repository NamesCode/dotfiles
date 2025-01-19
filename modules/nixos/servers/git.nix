{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.gitolite = {
    enable = true;
    dataDir = "/srv/git";

    # Configure gitolite
    # extraGitoliteRc

    # Sets the initial adminPubkey
    adminPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAy6DQPAN9Qo6k0VpD10kdV+fuHqofVKh/D4U2GFyXF7 Name@navi";
  };
}
