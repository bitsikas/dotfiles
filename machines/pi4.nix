# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  modulesPath,
  nixos-hardware,
  nixpkgs-unstable,
  ...
}: {
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];
  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["all"];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = true;
  environment.pathsToLink = ["/libexec"];

  programs.fish.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  # building sd image failes with missing sun4i-drm
  # but it's not necessary to run
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // {allowMissing = true;});
    })
  ];

  # boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  # boot.loader.generic-extlinux-compatible.enable = true;
  imports = [./hardware/pi4.nix];

  systemd.timers."dyndns" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "15m";
      OnUnitActiveSec = "15m";
      Unit = "dynamic-dns-updater.service";
    };
  };
  system.stateVersion = "24.05";
  systemd.services = {
    dynamic-dns-updater = {
      path = [pkgs.curl];
      script = "cat /etc/dyndns | curl -k -K -";
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
  security.sudo.enable = true;
  sdImage.compressImage = false;

  # this takes a lot of time sometimes
  documentation.man.generateCaches = false;

  # avoid building zfs
  disabledModules = ["profiles/base.nix"];
  services.resolved.enable = true;
  services.grocy = {
    enable = true;
    nginx.enableSSL = false;
    hostName = "grocy.bitsikas.home";
    settings = {
      currency = "RON";
    };
  };
  services.immich = {
    enable = true;
    mediaLocation = "/mnt/immich";
    machine-learning.enable = false;
  };
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;
    allowed-origins = ["https://cockpit.bitsikas.home" "http://cockpit.bitsikas.home"];
    settings = {
      WebService = {
        AllowUnencrypted = true;
      };
    };
  };

  services.printing = {
    enable = true;
    listenAddresses = ["*:631"];
    allowFrom = ["all"];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
  };
  services.printing.drivers = [
    pkgs.gutenprint
    # pkgs.brlaser
    # pkgs.brgenml1lpr
    # pkgs.brgenml1cupswrapper
  ];

  services.samba = {
    enable = true;
    package = pkgs.sambaFull;
    openFirewall = true;
    settings = {
      global = {
        "load printers" = "yes";
        "printing" = "cups";
        "printcap name" = "cups";
      };
      "printers" = {
        "comment" = "All Printers";
        "path" = "/var/spool/samba";
        "public" = "yes";
        "browseable" = "yes";
        # to allow user 'guest account' to print.
        "guest ok" = "yes";
        "writable" = "no";
        "printable" = "yes";
        "create mode" = 0700;
      };
    };
  };
  systemd.tmpfiles.rules = [
    "d /var/spool/samba 1777 root root -"
    "d /mnt/immich 1700 immich immich -"
  ];
  networking.hostName = "beershot"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.firewall = {
    allowedTCPPorts = [
      25344
      51413
      5055
      22
      80
    ];
    allowedUDPPorts = [
      25344
      51413
      51820
      config.services.tailscale.port
    ];
  };

  networking.useDHCP = lib.mkDefault true;
  # enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = "end0";
  networking.nat.internalInterfaces = ["wg0"];

  networking.nftables.enable = true;

  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = ["10.100.0.1/24"];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51820;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.nftables}/bin/nft add rule ip nat POSTROUTING ip saddr 10.100.0.0/24 oifname "end0" masquerade
      '';
      # postSetup = ''
      #   ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o end0 -j MASQUERADE
      # '';

      # This undoes the above command
      # postShutdown = ''
      #   ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o end0 -j MASQUERADE
      # '';
      postShutdown = ''
        ${pkgs.nftables}/bin/nft delete rule ip nat POSTROUTING ip saddr 10.100.0.0/24 oifname "end0" masquerade
      '';

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/etc/wg.private.key";

      peers = [
        # List of allowed peers.
        {
          # pixel8
          publicKey = "9qK6GvoTyWcIp4jk2X8iQ3h8hMSScdvGil2yF++SFX0=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = ["10.100.0.2/32"];
        }
        {
          # hp
          publicKey = "R2EmSxebQgZoXwaDCQGqjzDrf682zCjpVr6K31EVLFc=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = ["10.100.0.3/32"];
        }
        {
          # google tv.1.c
          publicKey = "ajr3fQ8BCQlJlvxh6Uj8nx7f76USfpf3JvbC6/I2TkA=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = ["10.100.0.4/32"];
        }
        {
          # google tv.2.c
          publicKey = "JL9trlL3GpTdsd/2DeA45wkNaUTXVnWu7mRKNdebH1A=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = ["10.100.0.6/32"];
        }
        {
          # google tv.1.calinesti
          publicKey = "shEwpX6UYga8K3rncTWzamh+DBSelwa3QiZ+xa5YBwY=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = ["10.100.0.5/32"];
        }
      ];
    };
  };

  services.openssh.enable = true;
  # services.mullvad-vpn.enable = true;
  services.tailscale.enable = true;

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINRASEE/kkq/U/MKRyN+3OTEofM7FgACxLzvuT/NtTWP "
    ];
  };

  environment.enableAllTerminfo = true;
  environment.systemPackages = with pkgs; [
    inetutils
    libraspberrypi
    raspberrypi-eeprom
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    # mullvad
    # yt-dlp
    sqlite
    qrencode
    wireproxy
  ];

  services.jellyseerr.enable = true;

  services.avahi = {
    publish = {
      enable = true;
      domain = true;
      addresses = true;
    };
    enable = true;
    nssmdns4 = true;
  };
  services.prowlarr = {
    package = nixpkgs-unstable.prowlarr;
    enable = true;
    openFirewall = true;
  };
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    dataDir = "/mnt/services/jellyfin";
  };
  services.bazarr = {
    enable = true;
    openFirewall = true;
  };
  services.sonarr = {
    package = import ../packages/sonarr.nix {
      inherit pkgs;
    };
    enable = true;
    openFirewall = true;
    dataDir = "/mnt/services/sonarr";
  };
  services.radarr = {
    enable = true;
    openFirewall = true;
    dataDir = "/mnt/services/radarr";
  };
  services.readarr = {
    enable = true;
    openFirewall = true;
    dataDir = "/mnt/services/readarr";
  };
  services.transmission = {
    enable = true; # Enable transmission daemon
    package = pkgs.transmission_4;
    openRPCPort = true; # Open firewall for RPC
    settings = {
      # Override default settings
      download-dir = "/mnt/Downloads";
      incomplete-dir = "/mnt/.incomplete";
      ratio-limit = 2;
      ratio-limit-enabled = true;
      rpc-bind-address = "0.0.0.0"; # Bind to own IP
      rpc-whitelist = "127.0.0.1,192.168.*.*,10.*.*.*,100.64.0.*"; # Whitelist your remote machine (10.0.0.1 in this example)
      rpc-host-whitelist = "transmission.bitsikas.home";
      rpc-host-whitelist-enabled = true;
      seed-queue-enabled = true;
      seed-queue-size = 5;
      speed-limit-down = 20000;
      speed-limit-down-enabled = true;
      speed-limit-up = 2000;
      speed-limit-up-enabled = true;
    };
  };

  # services.qbittorrent = {
  #   enable = true; # Enable qBittorrent daemon (qbittorrent-nox)
  #   openFirewall = true; # Open firewall for Web UI and torrenting port

  #   # Note: NixOS qBittorrent module uses 'torrentingPort' and 'webuiPort'
  #   # for the systemd service command line arguments and firewall.
  #   # The defaults are typically 6881 for torrenting and 8080 for webui.
  #   # You can override them if needed, e.g.:
  #   torrentingPort = 6881;
  #   webuiPort = 9093;

  #   # Most of the specific settings are passed through to the
  #   # qBittorrent configuration file (qBittorrent.conf) using serverConfig.
  #   # This option is a free-form attribute set.
  #   # Be aware that qBittorrent configuration uses [Sections] for its settings.
  #   serverConfig = {
  #     LegalNotice.Accepted = true; # Required to use the service

  #     # [Preferences] section equivalent settings
  #     Preferences = {
  #       # download-dir = "/mnt/Downloads"; -> mapped to "Downloads\\SavePath"
  #       "Downloads\\SavePath" = "/mnt/Downloads";

  #       # incomplete-dir = "/mnt/.incomplete"; -> mapped to "Downloads\\IncompleteSavePath"
  #       "Downloads\\IncompleteSavePath" = "/mnt/.incomplete";
  #       "Downloads\\TempPath" = true; # incomplete-dir-enabled

  #       # speed-limit-down = 20000; (kB/s) -> mapped to "Speed\\GlobalDLRateLimit" (KiB/s)
  #       # 20000 kB/s is 20480 KiB/s (qBittorrent uses KiB/s)
  #       "Speed\\GlobalDLRateLimit" = 20480;

  #       # speed-limit-down-enabled = true; -> mapped to "Speed\\GlobalDLRateLimitEnabled"
  #       "Speed\\GlobalDLRateLimitEnabled" = true;

  #       # speed-limit-up = 2000; (kB/s) -> mapped to "Speed\\GlobalULRateLimit" (KiB/s)
  #       # 2000 kB/s is 2048 KiB/s (qBittorrent uses KiB/s)
  #       "Speed\\GlobalULRateLimit" = 2048;

  #       # speed-limit-up-enabled = true; -> mapped to "Speed\\GlobalULRateLimitEnabled"
  #       "Speed\\GlobalULRateLimitEnabled" = true;

  #       # ratio-limit = 2; -> mapped to "Bittorrent\\RatioLimit"
  #       "Bittorrent\\RatioLimit" = 2.0;

  #       # ratio-limit-enabled = true; -> mapped to "Bittorrent\\RatioLimitEnabled"
  #       "Bittorrent\\RatioLimitEnabled" = true;

  #       # seed-queue-enabled = true; -> mapped to "Queueing\\MaxActiveTorrents" (active torrents = downloads + seeds)
  #       # Transmission's 'seed-queue-enabled' is closer to qBittorrent's "Max active torrents" option
  #       "Queueing\\MaxActiveTorrents" = 5; # Active = Downloading + Seeding

  #       # seed-queue-size = 5; -> mapped to "Queueing\\MaxActiveUploads"
  #       "Queueing\\MaxActiveUploads" = 5; # Max active seeds
  #     };

  #     # [WebUI] section equivalent settings
  #     WebUI = {
  #       # rpc-bind-address = "0.0.0.0"; -> qBittorrent binds to all interfaces by default
  #       # You can try "WebUI\\Address" but it's often more complex in qBittorrent.

  #       # rpc-whitelist and rpc-host-whitelist are roughly equivalent to
  #       # enabling LocalHostAuth and then relying on a reverse proxy's access control
  #       # or a separate VPN/firewall setup, as qBittorrent's webui access control is simpler.
  #       # You might set:
  #       LocalHostAuth = false; # To allow remote access without specific IP whitelisting

  #       # You should set a User/Password here for security, but note that
  #       # qBittorrent's service configuration is **tricky** with passwords,
  #       # which often need to be set in the WebUI first or provided as a PBKDF2 hash.
  #       # Username = "youruser";
  #       # Password_PBKDF2 = "<your_password_hash>";
  #     };
  #   };

  #   # For the rpc-bind-address and whitelist logic, in NixOS,
  #   # it's usually better to rely on system-level firewall rules or network
  #   # configuration (like a VPN/Tailscale/WireGuard) for access control.
  #   # The `openFirewall = true` above handles basic port opening.
  # };
  systemd.services.wireproxy = {
    wants = ["network-online.target"];
    after = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      User = "root";
      ExecStart = "${pkgs.wireproxy}/bin/wireproxy -c /etc/wireproxy.conf";
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };
  services.liverecord.enable = false;
  services.liverecord.destination = "/mnt/random";
  services.liverecord.hostnames = ["liverecord.bitsikas.home"];

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
    virtualHosts."transmission.bitsikas.home" = {
      forceSSL = false;
      enableACME = false;
      locations."/" = {
        proxyPass = "http://localhost:9091";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_read_timeout  300;
          proxy_set_header    Host                 $host;
          proxy_set_header    X-Forwarded-Proto    $scheme;
          proxy_set_header    X-Forwarded-Protocol $scheme;
          proxy_set_header    X-Real-IP            $remote_addr;
          proxy_pass_header   X-Transmission-Session-Id;
          proxy_set_header    X-Forwarded-Host     $host;
          proxy_set_header    X-Forwarded-Server   $host;
          proxy_set_header    X-Forwarded-For      $proxy_add_x_forwarded_for;
        '';
      };
    };
    virtualHosts."immich.bitsikas.home" = {
      forceSSL = false;
      enableACME = false;
      locations."/" = {
        proxyPass = "http://localhost:2283";
        proxyWebsockets = true;
      };
    };
    virtualHosts."jellyfin.bitsikas.home" = {
      forceSSL = false;
      enableACME = false;
      locations."/" = {
        proxyPass = "http://localhost:8096";
        proxyWebsockets = true;
      };
    };
    virtualHosts."radarr.bitsikas.home" = {
      forceSSL = false;
      enableACME = false;
      locations."/" = {
        proxyPass = "http://localhost:7878";
        proxyWebsockets = true;
      };
    };
    virtualHosts."sonarr.bitsikas.home" = {
      forceSSL = false;
      enableACME = false;
      locations."/" = {
        proxyPass = "http://localhost:8989";
        proxyWebsockets = true;
      };
    };
    virtualHosts."cockpit.bitsikas.home" = {
      forceSSL = false;
      enableACME = false;
      locations."/" = {
        proxyPass = "http://localhost:9090";
        proxyWebsockets = true;
      };
    };
    virtualHosts."jellyseer.bitsikas.home" = {
      forceSSL = false;
      enableACME = false;
      locations."/" = {
        proxyPass = "http://localhost:5055";
        proxyWebsockets = true;
      };
    };
    virtualHosts."prowlarr.bitsikas.home" = {
      forceSSL = false;
      enableACME = false;
      locations."/" = {
        proxyPass = "http://localhost:9696";
        proxyWebsockets = true;
      };
    };
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;
  systemd.services.transmission.serviceConfig.BindPaths = ["/mnt"];
  services.cron = {
    enable = true;
    systemCronJobs = ["0 4 * * * root find /mnt/random/ -type f -mtime +2 -delete"];
  };
}
