{
  modulesPath,
  lib,
  pkgs,
  nixpkgs-unstable,
  inputs,
  currentSystem,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
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
  services.unifi.mongodbPackage = nixpkgs-unstable.mongodb-ce;
  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 51720;
    settings = {
      logtail.enabled = false;
      server_url = "https://headscale.bitsikas.dev";

      dns = {
        base_domain = "bitsikas.home";
        extra_records = [
          {
            name = "jellyseer.bitsikas.home";
            type = "A";
            value = "100.64.0.1";
          }
          {
            name = "jellyfin.bitsikas.home";
            type = "A";
            value = "100.64.0.1";
          }
          {
            name = "sonarr.bitsikas.home";
            type = "A";
            value = "100.64.0.1";
          }
          {
            name = "radarr.bitsikas.home";
            type = "A";
            value = "100.64.0.1";
          }
          {
            name = "prowlarr.bitsikas.home";
            type = "A";
            value = "100.64.0.1";
          }
          {
            name = "liverecord.bitsikas.home";
            type = "A";
            value = "100.64.0.1";
          }
          {
            name = "cockpit.bitsikas.home";
            type = "A";
            value = "100.64.0.1";
          }
          {
            name = "grocy.bitsikas.home";
            type = "A";
            value = "100.64.0.1";
          }
          {
            name = "transmission.bitsikas.home";
            type = "A";
            value = "100.64.0.1";
          }
        ];
      };
    };
  };

  services.nginx = {
    enable = true;

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

  networking.useDHCP = lib.mkDefault true;
  system.stateVersion = "24.05";
  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
  };
}
