{
  modulesPath,
  lib,
  pkgs,
  nixpkgs-unstable,
  inputs,
  currentSystem,
  ...
}: let
  # Manually defining the 7.0.x version
  mongo7 = pkgs.mongodb-ce.overrideAttrs (oldAttrs: rec {
    version = "7.0.12"; # Use the latest stable 7.0 release
    src = pkgs.fetchurl {
      url = "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-${version}.tgz";
      # You will likely get a hash mismatch first;
      # replace this with the hash Nix suggests in the error message.
      hash = "sha256-Kgq66rOBKgNIVw6bvzNrpnGRxyoBCP0AWnfzs9ReVVk=";
    };
  });
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../modules/monitorin.nix
  ];
  nix = {
    settings.auto-optimise-store = true;
  };
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  fileSystems."/mnt/backups" = {
    device = "/dev/sdb";
    fsType = "ext4";
  };
  # this takes a lot of time sometimes
  documentation.man.generateCaches = false;
  programs.fish.enable = true;

  services.smtping = {
    enable = true;
    port = 2525;
  };
  services.cron = {
    enable = true;
    systemCronJobs = ["0 0 * * * root rsync -avz /var/lib/unifi/data/backup /mnt/backups/unifi"];
  };
  services.arthome.enable = true;
  services.arthome.letsencrypt = true;
  services.fittrack.enable = true;
  services.fittrack.letsencrypt = true;
  networking.nameservers = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
    fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
    dnsovertls = "true";
  };
  # services.pdfblancs.enable = true;
  services.ihasb33r.enable = true;
  services.ihasb33r.letsencrypt = true;
  services.miliacaffe.enable = true;
  services.miliacaffe.letsencrypt = true;

  security.sudo.enable = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  services.unifi.enable = true;
  services.unifi.openFirewall = true;
  services.unifi.unifiPackage = pkgs.unifi;
  services.unifi.mongodbPackage = mongo7;
  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 51720;
    settings = {
      logtail.enabled = false;
      server_url = "https://headscale.bitsikas.dev";

      dns = {
        nameservers.global = [
          "100.64.0.8"
          # "100.64.0.1"
          "fd7a:115c:a1e0::8"
          # "fd7a:115c:a1e0::1"
        ];

        base_domain = "bitsikas.home";
        extra_records =
          builtins.map (subdomain: {
            name = "${subdomain}.bitsikas.home";
            type = "A";
            value = "100.64.0.8";
          }) [
            "transmission"
            "jellyseer"
            "jellyfin"
            "sonarr"
            "radarr"
            "prowlarr"
            "liverecord"
            "cockpit"
            "grocy"
            "mealie"
            "transmission"
            "immich"
            "nzbget"
            "pihole"
            "freshrss"
            "monitoring"
          ];
      };
    };
  };

  services.nginx = {
    enable = true;
    commonHttpConfig = ''
      log_format vhost_combined '$remote_addr - $remote_user [$time_local] '
                                '"$request" $status $body_bytes_sent '
                                '"$http_referer" "$http_user_agent" $host:$server_port' ;
    '';
    appendHttpConfig = ''
      access_log /var/log/nginx/access.log vhost_combined;
    '';

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    # recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    virtualHosts.localhost = {
      locations."/" = {
        return = "200 '<html><body>It works</body></html>'";
        extraConfig = ''
          default_type text/html;
        '';
      };
    };
    virtualHosts."headscale.bitsikas.dev" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:51720";
        proxyWebsockets = true;
      };
    };
    virtualHosts."piftel.bitsikas.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        return = "200 '<html><body>It works</body></html>'";
        extraConfig = ''
          default_type text/html;
        '';
      };
    };
    virtualHosts."monitoring.piftel.bitsikas.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
      };
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
    virtualHosts."unifi.piftel.bitsikas.dev" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "https://127.0.0.1:8443/";

        extraConfig = ''
          # Proxy Unifi Controller UI traffic
          # The lack of '/' at the end is significant.
          proxy_ssl_verify off;
          proxy_ssl_session_reuse on;
          proxy_buffering off;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          ## Specific to Unifi Controller
          proxy_hide_header Authorization;
          proxy_set_header Referer "";
          proxy_set_header Origin "";
        '';
      };

      locations."/inform" = {
        # Proxy Unifi Controller inform endpoint traffic

        # The lack of '/' at the end is significant.
        proxyPass = "https://127.0.0.1:8080";
        extraConfig = ''
          proxy_ssl_verify off;
          proxy_ssl_session_reuse on;
          proxy_buffering off;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          ## Specific to Unifi Controller
          proxy_hide_header Authorization;
          proxy_set_header Referer "";
          proxy_set_header Origin "";
        '';
      };

      locations."/wss" = {
        # Proxy Unifi Controller UI websocket traffic

        # The lack of '/' at the end is significant.

        proxyPass = "https://127.0.0.1:8443";
        extraConfig = ''
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          ## Specific to Unifi Controller
          proxy_set_header Origin "";
          proxy_buffering off;
          proxy_hide_header Authorization;
          proxy_set_header Referer "";
        '';
      };
    };
  };
  services.grafana.settings.server.domain = "monitoring.piftel.bitsikas.dev";
  services.grafana.settings.server.root_url = "https://monitoring.piftel.bitsikas.dev/"; # Match your Nginx server_name
  services.grafana.settings.security = {
    csrf_trusted_origins = ["monitoring.piftel.bitsikas.dev"];
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "piftel@bitsikas.dev";

  environment.systemPackages = map lib.lowPrio [
    pkgs.inetutils
    pkgs.curl
    pkgs.gitMinimal
    pkgs.vim
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINRASEE/kkq/U/MKRyN+3OTEofM7FgACxLzvuT/NtTWP "
  ];
  nixpkgs.hostPlatform = lib.mkDefault currentSystem;
  services.fail2ban = {
    enable = true;
    # List of IPs that should NEVER be banned
    ignoreIP = ["127.0.0.1/8" "::1" "192.168.1.0/24"];

    # Global ban settings
    bantime = "24h"; # Initial ban duration
    maxretry = 10; # Max failures before ban
  };
  services.fail2ban.jails = {
    sshd.settings.enabled = false;
    nginx-http-auth = ''
      enabled = true
      filter = nginx-http-auth
      port = http,https
      logpath = /var/log/nginx/error.log
      backend = auto
      maxretry = 10
    '';
    nginx-4xx = ''
      enabled = true
      filter = nginx-4xx
      port = http,https
      logpath = /var/log/nginx/access.log
      backend = auto
      findtime = 600
      maxretry = 3
    '';

    nginx-botsearch = ''
      enabled = true
      filter = nginx-botsearch
      port = http,https
      logpath = /var/log/nginx/access.log
      maxretry = 10
      backend = auto
    '';
    nginx-ip-direct = ''
      enabled  = true
      port     = http,https
      filter   = nginx-ip-direct
      logpath  = /var/log/nginx/access.log
      maxretry = 1
      bantime  = 48h
      findtime = 600
      backend = auto
    '';
  };
  environment.etc."fail2ban/filter.d/nginx-4xx.conf".text = ''
    [Definition]
    failregex = ^<HOST> -.*"(GET|POST|HEAD).*HTTP.*" (404|403|400) .*$
    ignoreregex = ^<HOST> -.*"(GET /favicon.*|.*monitoring\.piftel\.bitsikas\.dev.*)"$
  '';
  environment.etc."fail2ban/filter.d/nginx-ip-direct.conf".text = ''
    [Definition]
    # Matches the attacker IP <HOST> and looks for your Server IP at the end of the log line
    # Adjusting for the specific log format you provided:
    failregex = ^<HOST> -.* 95\.217\.185\.160:(80|443)\s*$
    ignoreregex =
  '';

  networking.useDHCP = lib.mkDefault true;
  system.stateVersion = "24.05";
  networking.firewall = {
    allowedTCPPorts = [
      25
      2525
      80
      443
    ];
  };
}
