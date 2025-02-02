{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Setup gitolite
  services.gitolite = {
    enable = true;
    user = "git";
    dataDir = "/srv/git";

    # Configure gitolite
    extraGitoliteRc = ''
      $RC{SITE_INFO} = "Name's Git server! Running Gitolite and uysdfeuy <3";
      push( @{$RC{ENABLE}}, 'Kindergarten' ); # WARN: DO NOT REMOVE. STOPS USERS BEING DUMB.
      push( @{$RC{ENABLE}}, 'set-default-roles' ); # Enables us to set default roles.
      push( @{$RC{ENABLE}}, 'create' ); # Enables us to set default roles.
      push( @{$RC{ENABLE}}, 'fork' ); # Enables us to set default roles.
      push( @{$RC{ENABLE}}, 'mirror' ); # Enables us to set default roles.
      push( @{$RC{ENABLE}}, 'readme' ); # Enables us to set default roles.
      push( @{$RC{ENABLE}}, 'sskm' ); # Enables us to set default roles.
      push( @{$RC{ENABLE}}, 'D' ); # Enables us to set default roles.

      # @{$RC{ENABLE}} = grep { $_ ne 'desc' } @{$RC{ENABLE}}; # disable the command/feature
    '';

    # Sets the initial adminPubkey
    adminPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPXLaWnHGxCOd9g7KwkISKeXBpTKy7mdulKdjP/pRezm Name@navi";
  };

  # WARN: This is super important. Without adding it to the ssh user-group it can NOT use ssh.
  users.users.git.extraGroups = [ "allowed-ssh" ];
}
