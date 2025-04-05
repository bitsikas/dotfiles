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
  services.artframe.enable = true;
  services.fittrack.enable = true;
  services.pdfblancs.enable = true;
  services.ihasb33r.enable = true;
  services.miliacaffe.enable = true;

  security.sudo.enable = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  services.unifi.enable = true;
  services.unifi.openFirewall = true;
  services.unifi.unifiPackage = pkgs.unifi8;
  services.unifi.mongodbPackage = nixpkgs-unstable.mongodb-ce;
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
    allowedUDPPorts = [];
  };
}
