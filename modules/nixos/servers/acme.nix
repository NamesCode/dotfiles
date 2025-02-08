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
      server = "https://acme-staging-v02.api.letsencrypt.org/directory"; # NOTE: Remove this in prod
      email = "lasagna@garfunkles.space";
      dnsProvider = "porkbun";
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
      };

      # PinBiz certs
      "pins-and-badges.com" = {
        environmentFile = "/var/secrets/acme-pab-pb.env";
      };
    };
  };
}
