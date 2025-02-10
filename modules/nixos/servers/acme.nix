{
  lib,
  config,
  pkgs,
  ...
}:
{
  security.acme = {
    acceptTerms = true;

    defaults = {
      # server = "https://acme-staging-v02.api.letsencrypt.org/directory"; # NOTE: Remove this in prod
      email = "lasagna@garfunkles.space";
      dnsProvider = "porkbun";

      # Really we should give an isolated group based on how many services need to read it.
      # If someone who shouldn't have access, *gets* access then we're buggered as they can
      # read all of the certs.
      # For now, let's hope this doesn't happen...
      group = "access-acme";

      # Move certs to a more preferred location
      postRun = ''
        mkdir -p ../certs
        domain=$(basename "$(pwd)")

        cp cert.pem "../certs/$domain.cert" 
        cp key.pem "../certs/$domain.key" 

        chown acme "../certs/$domain.cert"
        chown acme "../certs/$domain.key"
        chgrp access-acme "../certs/$domain.cert"
        chgrp access-acme "../certs/$domain.key"
      '';
    };

    certs = {
      # Garfies certs
      "garfunkles.space" = {
        dnsProvider = "cloudflare";
        environmentFile = "/var/secrets/acme-garfunkles-space-cf.env";
      };

      # Puppyboys qt certifications
      "puppyboy.cloud" = {
        environmentFile = "/var/secrets/acme-puppyboy-pb.env";

        # Im fine with this since atm they are all on the same machine anyway. When one moves so will the cert reg
        extraDomainNames = [
          "ftp.puppyboy.cloud"
          "git.puppyboy.cloud"
        ];
      };

      # PinBiz certs
      "pins-and-badges.com" = {
        environmentFile = "/var/secrets/acme-pab-pb.env";
      };
    };
  };

  # Create access group
  users.groups.access-acme = { }; # WARN: I think we have some pretty serious security implications here. Anyone with this group can edit challenges AND access certs...
}
