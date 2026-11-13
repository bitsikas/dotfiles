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
  nix = {
    settings.auto-optimise-store = true;
    package = pkgs.nixVersions.stable; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  myFeatures.desktop = true;

  # --- Memory tuning ---
  # Cap journald: defaults are unbounded and grow to many GB.
  services.journald.extraConfig = ''
    SystemMaxUse=500M
    MaxRetentionSec=2week
  '';
  # Compressed swap in RAM: faster than NVMe swap, less disk wear,
  # helps when transient jobs (e.g. liverecord-delay) spike.
  zramSwap.enable = true;

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = true;
  environment.pathsToLink = ["/libexec"];

  programs.fish.enable = true;

  # nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

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
  imports = [./hardware/gmktec.nix ../modules/monitorin.nix];

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
  # sdImage.compressImage = false;

  # this takes a lot of time sometimes
  documentation.man.generateCaches = false;

  home-manager.users.kostas.myFeatures.desktop = true;
  # avoid building zfs
  disabledModules = ["profiles/base.nix"];
  services.freshrss = {
    enable = true;
    # authType = "none";
    virtualHost = "freshrss.bitsikas.home";
    baseUrl = "http://freshrss.bitsikas.home/";
    passwordFile = "/var/lib/freshrss.password";
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    settings.port = 47989;
    settings.file_apps = "/var/lib/sunshine-apps.json";
    # applications.apps = [];
  };

  services.mealie = {
    enable = true;
  };
  services.grocy = {
    enable = false;
    nginx.enableSSL = false;
    hostName = "grocy.bitsikas.home";
    settings = {
      currency = "RON";
    };
  };
  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    port = 11434;
    openFirewall = true;
    environmentVariables = {
      OLLAMA_MODELS = "/mnt/ollama";
    };
  };
  services.immich = {
    package = nixpkgs-unstable.immich;
    enable = true;
    mediaLocation = "/mnt/immich";
    machine-learning.enable = false;

    # 1. Tell the Node server not to spawn a worker per core.
    #    Default scales with CPU count; on an 8C/16T 7730U that's a lot.
    environment = {
      IMMICH_WORKERS = "2"; # API workers
      IMMICH_IMAGE_PROCESSING_CONCURRENCY = "1";
      IMMICH_VIDEO_PROCESSING_CONCURRENCY = "1";
      IMMICH_THUMB_IMAGE_THREAD_COUNT = "1";
      IMMICH_THUMB_VIDEO_THREAD_COUNT = "1";
      IMMICH_THUMB_GENERATION_CONCURRENCY = "1";
      IMMICH_METADATA_CONCURRENCY = "1";
    };
  };

  # 2. PostgreSQL is the biggest single win. Override its memory settings
  #    independently of the immich module — these are pure postgresql.* opts.
  services.postgresql.settings = {
    shared_buffers = "256MB"; # default auto-tunes too high on small boxes
    work_mem = "8MB";
    maintenance_work_mem = "64MB";
    effective_cache_size = "1GB";
    # huge_pages = "off";                # uncomment if you see numa complaints
  };

  services.samba = {
    enable = true;
    package = pkgs.sambaFull;
    openFirewall = true;
    settings = {
      global = {};
    };
  };
  systemd.tmpfiles.rules = [
    "d /mnt/immich 1700 immich immich -"
    "d /var/lib/services/sonarr 1770 sonarr streaming -"
    "d /var/lib/services/flaresolverr 1770 flaresolverr streaming -"
    "d /var/lib/services/radarr 1770 radarr streaming -"
    "d /var/lib/services/readarr 1770 readarr streaming -"
    "d /var/lib/services/jellyfin 1770 jellyfin streaming -"
    "d /mnt/ollama 0750 ollama ollama -"
  ];
  networking.interfaces.enp1s0.wakeOnLan.enable = true;
  networking.hostName = "gmktec"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.firewall = {
    allowedTCPPorts = [
      22
      25344
      47984
      47989
      47990
      48010
      5055
      51413
      53
      80
      8080
      8551
    ];
    allowedUDPPorts = [
      25344
      51413
      51820
      53
      config.services.tailscale.port
    ];
    checkReversePath = "loose"; # <--- ADD THIS LINE
    trustedInterfaces = ["tailscale0"];
  };
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 47998;
      to = 48000;
    }
    {
      from = 8000;
      to = 8010;
    }
  ];
  networking.nat = {
    enable = true;
    externalInterface = "enp1s0";
    internalInterfaces = ["tailscale0"];
  };
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "vm.swappiness" = 10;
  };
  # Point system DNS at blocky (local resolver).
  networking.nameservers = ["127.0.0.1"];
  services.blocky = {
    enable = true;
    settings = {
      ports.dns = 53; # Port for incoming DNS Queries.
      upstreams.groups.default = [
        "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
      ];
      # For initially solving DoH/DoT Requests when no system Resolver is available.
      bootstrapDns = {
        upstream = "https://one.one.one.one/dns-query";
        ips = ["1.1.1.1" "1.0.0.1"];
      };
      #Enable Blocking of certain domains.
      blocking = {
        denylists = {
          #Adblocking
          ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
          #Another filter for blocking adult sites
          adult = ["https://blocklistproject.github.io/Lists/porn.txt"];
          #You can add additional categories
        };
        #Configure what block categories are used
        clientGroupsBlock = {
          default = ["ads"];
          kids-ipad = ["ads" "adult"];
        };
      };
    };
  };

  networking.useDHCP = lib.mkDefault true;

  networking.nftables.enable = true;

  services.openssh.enable = true;
  # services.mullvad-vpn.enable = true;
  services.tailscale.enable = true;
  #services.tailscale.userRoutingFeatures = "both";
  services.networkd-dispatcher = {
    enable = true;
    rules."50-tailscale" = {
      onState = ["routable"];
      script = ''
        ${pkgs.ethtool}/sbin/ethtool -K enp1s0 rx-udp-gro-forwarding on rx-gro-list off
      '';
    };
  };

  services.displayManager = {
    gdm.enable = false;
    gdm.debug = false;
  };
  services.desktopManager = {
    gnome.enable = false;
    plasma6.enable = false;
    gnome.debug = false;
  };

  users.groups.streaming = {};
  users.users.jellyfin.extraGroups = ["streaming"];
  users.users.sonarr.extraGroups = ["streaming"];
  # users.users.flaresolverr.extraGroups = ["streaming"];
  users.users.radarr.extraGroups = ["streaming"];
  users.users.transmission.extraGroups = ["streaming"];

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINRASEE/kkq/U/MKRyN+3OTEofM7FgACxLzvuT/NtTWP "
    ];
  };

  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["all"];

  fonts.packages = with pkgs; [
    fira-code
    noto-fonts
    jetbrains-mono
    noto-fonts-color-emoji
    nerd-fonts.fira-code
    ubuntu-classic
    cantarell-fonts
    roboto
    roboto-serif
  ];
  environment.enableAllTerminfo = true;
  environment.systemPackages = with pkgs; [
    inetutils
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    ethtool
    sqlite
    qrencode
    wireproxy
    firefox
    inkscape
    gimp
    krita
    # blender
    freecad
    bottles
    # bambu-studio
    prusa-slicer
    super-slicer
    orca-slicer
    libreoffice
  ];

  services.jellyseerr.enable = false;

  services.avahi = {
    publish = {
      enable = true;
      domain = true;
      userServices = true;
      addresses = true;
    };
    enable = true;
    nssmdns4 = true;
  };

  systemd.services.avahi-alias = {
    description = "Publish mDNS alias for service.machinename.local";
    after = ["network.target" "avahi-daemon.service"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      # Replace 'service.machinename.local' with your desired address
      ExecStart = pkgs.writeShellScript "publish-avahi-alias" ''
        IP=$(${pkgs.hostname}/bin/hostname -I | ${pkgs.gawk}/bin/awk '{print $1}')

        NAMES=("liverecord" "jellyfin" "flaresolverr" "sonarr" "radarr" "transmission" "immich" "prowlarr" "cockpit" "jellyseer" "paperless" "ollama")

        # Launch a background process for each name
        for NAME in "''${NAMES[@]}"; do
          ${pkgs.avahi}/bin/avahi-publish -a -R "$NAME.gmktec.local" "$IP" &
        done

        # Keep the main script running so systemd doesn't kill the children
        wait
      '';
      Restart = "always";
      User = "root";
      Group = "avahi";
    };
  };
  services.prowlarr = {
    package = nixpkgs-unstable.prowlarr;
    enable = true;
    openFirewall = true;
  };
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    dataDir = "/var/lib/services/jellyfin";
  };
  services.bazarr = {
    enable = false;
    openFirewall = false;
  };
  services.flaresolverr = {
    enable = true;
    openFirewall = true;
    #    dataDir = "/var/lib/services/flaresolverr";
  };
  services.sonarr = {
    enable = true;
    openFirewall = true;
    dataDir = "/var/lib/services/sonarr";
  };
  services.radarr = {
    enable = true;
    openFirewall = true;
    dataDir = "/var/lib/services/radarr";
  };
  services.readarr = {
    enable = false;
    openFirewall = false;
    dataDir = "/var/lib/services/readarr";
  };
  services.transmission = {
    enable = true; # Enable transmission daemon
    package = pkgs.transmission_4;
    openRPCPort = true; # Open firewall for RPC
    settings = {
      # Override default settings
      download-dir = "/var/lib/Downloads";
      incomplete-dir = "/var/lib/.incomplete";
      ratio-limit = 2;
      ratio-limit-enabled = true;
      rpc-bind-address = "0.0.0.0"; # Bind to own IP
      rpc-whitelist = "127.0.0.1,192.168.*.*,10.*.*.*,100.64.0.*"; # Whitelist your remote machine (10.0.0.1 in this example)
      rpc-host-whitelist = "transmission.bitsikas.home";
      rpc-host-whitelist-enabled = true;
      seed-queue-enabled = true;
      seed-queue-size = 5;
      speed-limit-down = 10000;
      speed-limit-down-enabled = true;
      speed-limit-up = 2000;
      speed-limit-up-enabled = true;
      umask = 2;
    };
  };

  systemd.services.wireproxy-3 = {
    wants = ["network-online.target"];
    after = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      User = "root";
      ExecStart = "${pkgs.wireproxy}/bin/wireproxy -c /etc/wireproxy-3.conf";
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };

  systemd.services.wireproxy-2 = {
    wants = ["network-online.target"];
    after = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      User = "root";
      ExecStart = "${pkgs.wireproxy}/bin/wireproxy -c /etc/wireproxy-2.conf";
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };
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
  services.liverecord.enable = true;
  services.liverecord.final_storage = "/mnt/random";
  services.liverecord.hostnames = ["liverecord.bitsikas.home" "liverecord.gmktec.local"];
  services.liverecord.proxy = "socks5://127.0.0.1:25344";
  services.liverecord.delay-seconds = 1.5;
  services.sabnzbd.enable = false;

  services.nginx = {
    enable = true;

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    # recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    virtualHosts =
      builtins.listToAttrs (
        map (
          svc: {
            name = svc.name;
            value = {
              forceSSL = false;
              enableACME = false;
              locations."/" = {
                proxyPass = svc.proxyPass;
                proxyWebsockets = true;
              };
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
              '';
            };
          }
        ) [
          {
            name = "mealie.bitsikas.home";
            proxyPass = "http://localhost:9000";
          }
          {
            name = "monitoring.bitsikas.home";
            proxyPass = "http://127.0.0.1:3000";
          }
          {
            name = "jellyfin.bitsikas.home";
            proxyPass = "http://localhost:8096";
          }
          {
            name = "jellyfin.gmktec.local";
            proxyPass = "http://localhost:8096";
          }

          {
            name = "paperless.bitsikas.home";
            proxyPass = "http://localhost:28981";
          }

          {
            name = "flaresolverr.bitsikas.home";
            proxyPass = "http://localhost:8191";
          }
          {
            name = "sonarr.bitsikas.home";
            proxyPass = "http://localhost:8989";
          }

          {
            name = "radarr.bitsikas.home";
            proxyPass = "http://localhost:7878";
          }
          {
            name = "radarr.gmktec.local";
            proxyPass = "http://localhost:7878";
          }

          {
            name = "immich.bitsikas.home";
            proxyPass = "http://localhost:2283";
          }
          {
            name = "immich.gmktec.local";
            proxyPass = "http://localhost:2283";
          }

          {
            name = "nzbget.bitsikas.home";
            proxyPass = "http://localhost:6789";
          }
          {
            name = "nzbget.gmktec.local";
            proxyPass = "http://localhost:6789";
          }

          {
            name = "ollama.bitsikas.home";
            proxyPass = "http://127.0.0.1:11434";
          }
          {
            name = "ollama.gmktec.local";
            proxyPass = "http://127.0.0.1:11434";
          }

          # {
          #   name = "cockpit.gmktec.local";
          #   proxyPass = "http://localhost:9090";
          # }
          {
            name = "cockpit.bitsikas.home";
            proxyPass = "http://localhost:9090";
          }
          {
            name = "jellyseer.gmktec.local";
            proxyPass = "http://localhost:5055";
          }
          {
            name = "jellyseer.bitsikas.home";
            proxyPass = "http://localhost:5055";
          }
          {
            name = "prowlarr.gmktec.local";
            proxyPass = "http://localhost:9696";
          }
          {
            name = "prowlarr.bitsikas.home";
            proxyPass = "http://localhost:9696";
          }
        ]
      )
      // {
        localhost = {
          locations."/" = {
            return = "200 '<html><body>It works</body></html>'";
            extraConfig = ''
              default_type text/html;
            '';
          };
        };
        "transmission.bitsikas.home" = {
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
      };
  };
  services.paperless = {
    enable = true;
    consumptionDirIsPublic = true;
    # address = "100.64.0.8";
    settings = {
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
      PAPERLESS_URL = "http://paperless.bitsikas.home";
    };
  };

  services.grafana.settings.server.domain = "monitoring.bitsikas.home";
  services.grafana.settings.server.root_url = "http://monitoring.bitsikas.home/"; # Match your Nginx server_name
  services.grafana.settings.security = {
    csrf_trusted_origins = ["monitoring.bitsikas.home"];
  };

  systemd.services.transmission.serviceConfig.BindPaths = ["/mnt"];
  services.cron = {
    enable = true;
    systemCronJobs = ["0 4 * * * root find /mnt/random/ -type f -mtime +3 -delete"];
  };
}
