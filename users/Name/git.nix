{ config, pkgs, ... }:
{
  # Configures git
  programs.git = {
    enable = true;
    userName = "Name";
    userEmail = "lasagna@garfunkles.space";

    lfs.enable = true;

    extraConfig = {
      # Set default branch to be main instead of master
      init.defaultBranch = "main";

      # Git signatures
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/general.pub";

      # Rebase on every pull
      pull.rebase = true;

      ## Better diffs

      # Show full differences in a commit
      commit.verbose = true;

      # Show the whole code in a merge conflict
      merge.conflictStyle = "diff3";
    };
  };
}
