{
  lib,
  config,
  pkgs,
  ...
}:
let
  domain = "puppyboy.cloud";
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

    virtualHosts = {
      # "git.${domain}" = {
      #   locations."/" = {
      #     proxyPass = "http://127.0.0.1:3000";
      #     extraConfig = "limit_req zone=basic burst=10";
      #   };
      # };
    };

    # TODO:
    # - [ ] Disable puppyboy related stuff if config.puppyboy-site-or-wtv.enable = false
    # - [ ] Auto ACME for users
    appendHttpConfig = ''
      # Setup ratelimits
      limit_req_zone $binary_remote_addr zone=basic:10m rate=5r/s;

      # Setup caching
      proxy_cache_path /tmp/nginx/cache/usersites/ levels=1:2 keys_zone=usersites:50m max_size=500m inactive=30m use_temp_path=off;

      # static_site_example /srv/www/usersites/
      # ip_example 127.0.0.1:42069
      map $host $backend {
          default 410;
          include /etc/nginx/domain_to_webserver.map;
      }

      server {
        listen 80 default_server;
        # listen 443 ssl default_server;
        server_name _;

        # Errors def
        locations = /puppyboy-errors {
          root /srv/www/puppyboy/errors/;
          internal;
        };

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

        # Dynamically route the domain
        location / {
          limit_req zone=basic burst=10

          # Conditional routing
          if ($backend ~* "127.0.0.1") {
            proxy_intercept_errors off;
            proxy_pass http://$backend;
            break;
          }

          if ($backend ~* "^[4-5]\d\d$") {
            return $backend; # Errors be gone!
          }

          root $backend;
          index index.html;
          try_files $uri $uri/ /404.html =404;
        }
      }
    '';
  };

  # Create necessary folders
  systemd.tmpfiles.rules = [
    "d /tmp/nginx/cache/usersites 0600 nginx nginx -"
  ];
}
