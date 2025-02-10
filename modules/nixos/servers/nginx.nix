{
  lib,
  config,
  pkgs,
  ...
}:
let
  domain = "puppyboy.cloud";
  acmeDir = "/var/lib/acme";
in
{
  services.nginx = {
    enable = true;

    # Server
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;

    # Compression
    recommendedZstdSettings = true;
    recommendedGzipSettings = true;
    recommendedBrotliSettings = true;

    # Increase bucket size. Idk what it does but it makes shit work soooooo
    mapHashBucketSize = 128;

    virtualHosts = {
      "_" = {
        default = true;
        addSSL = true;
        sslCertificate = "${acmeDir}/certs/$cert_domain.cert";
        sslCertificateKey = "${acmeDir}/certs/$cert_domain.key";

        locations = {
          # Custom errors
          "/puppyboy-errors/" = {
            alias = "/srv/www/puppyboy/errors/";
            extraConfig = "internal;";
          };

          "/.well-known/acme-challenge/" = {
            alias = "${acmeDir}/challenges/$host/.well-known/acme-challenge/";
            tryFiles = "$uri =404";
          };

          # Dynamically route the domain
          "/" = {
            index = "index.html";
            tryFiles = "$uri $uri/ /404.html =404";

            extraConfig = ''
              limit_req zone=basic burst=10;
              proxy_intercept_errors off;

              # Conditional routing
              if ($backend ~* "127.0.0.1") {
                proxy_pass http://$backend;
                break;
              }

              # Error code handling
              if ($backend = "pay-up") {
                return 402; # PAY ME!!! >:C
              }

              if ($backend = "not-mine") {
                return 404; # Not found :<
              }

              if ($backend = "taken-down") {
                return 410; # Taken care of bwoss... ( • ̀ω•́ )✧
              }

              # Treat as a static site
              root $backend;
            '';
          };
        };

        extraConfig = ''
          limit_req zone=basic burst=10;

          # 4XX errors
          error_page 400 /puppyboy-errors/400-bad-request.html;
          error_page 402 /puppyboy-errors/402-payment-required.html;
          error_page 403 /puppyboy-errors/403-forbiden.html;
          error_page 404 /puppyboy-errors/404-not-found.html;
          error_page 408 /puppyboy-errors/408-timeout.html;
          error_page 410 /puppyboy-errors/410-gone.html;
          error_page 429 /puppyboy-errors/429-ratelimit.html;

          # 5XX errors
          error_page 500 /puppyboy-errors/500-server-error.html;
          error_page 508 /puppyboy-errors/508-loop.html;


          # Handle loops
          if ($http_max_forwards = "") {
            set $max_forwards "11";
          }

          set $max_forwards "$max_forwards-1";

          if ($max_forwards = 0) {
            return 508;  # Looping qwq
          }

          proxy_set_header Max-Forwards "$max_forwards";
        '';
      };

      "ftp.${domain}" = {
        root = "/srv/ftp";
        addSSL = true;
        sslCertificate = "${acmeDir}/certs/puppyboy.cloud.cert";
        sslCertificateKey = "${acmeDir}/certs/puppyboy.cloud.key";

        locations."/" = {
          index = ".index.html";
          extraConfig = "limit_req zone=basic burst=10;";
        };

        extraConfig = ''
          limit_req zone=basic burst=10;

          # Covers the USER/FILE stuff loll
          location ~ "^\/([^\/]+)(.+)?$" {
            set $user $1;
            set $file $2;

            if ($file = "") {
              set $file ".filelist.html";
            }

            # Use alias to map to the correct user/public path
            alias /srv/ftp/$user/public/;

            # Try to serve the file or index.html, else return 404
            try_files $file $file/.filelist.html =404;
          }
        '';
      };
    };

    # TODO:
    # - [X] Purify config 
    # - [ ] Disable puppyboy related stuff if config.puppyboy-site-or-wtv.enable = false
    # - [ ] Auto ACME for users
    appendHttpConfig = ''
      # Setup ratelimits
      limit_req_zone $binary_remote_addr zone=basic:10m rate=5r/s;

      # Setup caching
      # proxy_cache_path /tmp/nginx/cache/usersites levels=1:2 keys_zone=usersites:50m max_size=500m inactive=30m use_temp_path=off; # This doesnt work and I cba to figure out why
      proxy_cache_path /var/cache/nginx/usersites levels=1:2 keys_zone=usersites:50m max_size=500m inactive=30m use_temp_path=off;


      # static_site_example /srv/www/usersites/
      # ip_example 127.0.0.1:42069
      map "$host" $backend {
        default not-mine;
        include /etc/nginx/domain_to_webserver.map;
      }

      # Remove subdomains and map host to a cert. In future make an exceptions list incase its needed
      map $ssl_server_name $cert_domain {
        # default $ssl_server_name;
        ~^([a-z0-9-_-]+\.)([a-z0-9-_-]+\.[a-z0-9-_-]+)$ $2;
        ~^([a-z0-9-_-]+\.[a-z0-9-_-]+\.)([a-z0-9-_-]+\.[a-z0-9-_-]+)$ $2;
        ~^([a-z0-9-_-]+\.[a-z0-9-_-]+\.[a-z0-9-_-]+\.)([a-z0-9-_-]+\.[a-z0-9-_-]+)$ $2;
      }
    '';
  };

  # Create necessary folders
  systemd.tmpfiles.rules = [
    "f /etc/nginx/domain_to_webserver.map 0600 nginx nginx -"
  ];

  # Allow cert access
  users.users.nginx.extraGroups = [ "access-acme" ];

  systemd.timers."acme-usersites" = {
    wantedBy = [ "timers.target" ];
    description = "Renew ACME for usersites";
    timerConfig = {
      AccuracySec = "28800s";
      FixedRandomDelay = true;
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "24h";
      Unit = "acme-usersites.service";
    };
  };

  systemd.services."acme-usersites" = {
    script = ''
      #!/bin/env sh

      QUERY="SELECT domains, email FROM main;"

      # Loop through each row from the query
      ${pkgs.sqlite}/bin/sqlite3 /var/lib/puppyboy/database.sqlite3 "$QUERY" | while IFS='|' read -r domains email; do
        domain=$(echo "$domains" | ${pkgs.gawk}/bin/awk '{print $1}')

        mkdir -p "/var/lib/acme/challenges/$domain/"
        chown acme "/var/lib/acme/challenges/$domain/"
        chgrp access-acme "/var/lib/acme/challenges/$domain/"

        echo "Running acme for domains: $domains, email: $email" >> /var/log/acme-usersites.log
        ${pkgs.sudo}/bin/sudo -u acme ${pkgs.lego}/bin/lego --accept-tos --path /var/lib/acme/.lego --email="$email" --domains="$domains" --http --http.webroot="/var/lib/acme/challenges/$domain/" run || \
        echo "Failed acme for domains: $domains, email: $email" >> /var/log/acme-usersites.log

        # Move certs to ideal dir
        cd /var/lib/acme/.lego/certificates/

        cp $domain.crt "../../certs/$domain.cert" 
        cp $domain.key "../../certs/$domain.key" 

        chmod 640 "../../certs/$domain.cert"
        chmod 640 "../../certs/$domain.key"
        chown acme "../../certs/$domain.cert"
        chown acme "../../certs/$domain.key"
        chgrp access-acme "../../certs/$domain.cert"
        chgrp access-acme "../../certs/$domain.key"
      done
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  # Open firewall
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
