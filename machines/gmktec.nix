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

  # nixpkgs.config.permittedInsecurePackages = [
  #   "aspnetcore-runtime-6.0.36"
  #   "aspnetcore-runtime-wrapped-6.0.36"
  #   "dotnet-sdk-6.0.428"
  #   "dotnet-sdk-wrapped-6.0.428"
  # ];

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
  imports = [./hardware/gmktec.nix];

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

  # avoid building zfs
  disabledModules = ["profiles/base.nix"];
  services.resolved.enable = true;
  services.resolved.extraConfig = ''
    DNSStubListener=no
  '';
  services.pihole-web.enable = true;
  services.pihole-web.ports = ["31480r" "31443s"];
  services.pihole-ftl = {
    enable = true;
    lists = [
      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
      }
      {
        url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt";
      }
      {
        url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/doh-vpn-proxy-bypass.txt";
      }
    ];

    settings = builtins.fromTOML ''
      [dns]
      upstreams = ["1.1.1.1", "1.0.0.1", "8.8.8.8"]
      listeningMode = "ALL"
    '';
  };
  services.freshrss = {
    enable = true;
    # authType = "none";
    virtualHost = "freshrss.bitsikas.home";
    baseUrl = "http://freshrss.bitsikas.home/";
    passwordFile = "/var/lib/freshrss.password";
  };
  services.mealie = {
    enable = true;
  };
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
    "d /var/lib/services/sonarr 1770 sonarr streaming -"
    "d /var/lib/services/radarr 1770 radarr streaming -"
    "d /var/lib/services/readarr 1770 readarr streaming -"
    "d /var/lib/services/jellyfin 1770 jellyfin streaming -"
  ];
  networking.hostName = "gmktec"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.firewall = {
    allowedTCPPorts = [
      25344
      51413
      31480
      31443
      5055
      22
      80
      53
    ];
    allowedUDPPorts = [
      25344
      51413
      51820
      53
      config.services.tailscale.port
    ];
  };
  networking.nat = {
    enable = true;
    externalInterface = "enp1s0";
    internalInterfaces = ["tailscale0"];
  };

  networking.useDHCP = lib.mkDefault true;

  networking.nftables.enable = true;

  services.openssh.enable = true;
  # services.mullvad-vpn.enable = true;
  services.tailscale.enable = true;
  services.networkd-dispatcher = {
    enable = true;
    rules."50-tailscale" = {
      onState = ["routable"];
      script = ''
        NETDEV=$(ip -o route get 8.8.8.8 | cut -f 5 -d " ")
        export NETDEV
        ${pkgs.ethtool}/sbin/ethtool -K "$NETDEV" rx-udp-gro-forwarding on rx-gro-list off
      '';
    };
  };

  services.displayManager = {
    gdm.enable = true;
    gdm.wayland = true;
    gdm.debug = false;
  };
  services.desktopManager = {
    gnome.enable = true;
    plasma6.enable = true;
    gnome.debug = false;
  };

  users.groups.streaming = {};
  users.users.jellyfin.extraGroups = ["streaming"];
  users.users.sonarr.extraGroups = ["streaming"];
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
    sqlite
    qrencode
    wireproxy
    firefox
    inkscape
    gimp
    krita
    blender
    freecad
    bottles
    bambu-studio
    prusa-slicer
    super-slicer
    orca-slicer
    libreoffice
  ];

  services.jellyseerr.enable = true;

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

        NAMES=("liverecord" "jellyfin" "sonarr" "radarr" "transmission" "immich" "prowlarr" "cockpit" "jellyseer")

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
    enable = true;
    openFirewall = true;
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
    enable = true;
    openFirewall = true;
    dataDir = "/var/lib/services/readarr";
  };
  services.transmission = {
    enable = true; # Enable transmission daemon
    package = pkgs.transmission_4;
    openRPCPort = true; # Open firewall for RPC
    settings = {
      # Override default settings
      download-dir = "/var/tmp/Downloads";
      incomplete-dir = "/var/tmp/.incomplete";
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
  services.sabnzbd.enable = true;

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
            };
          }
        ) [
          {
            name = "mealie.bitsikas.home";
            proxyPass = "http://localhost:9000";
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
            name = "sonarr.bitsikas.home";
            proxyPass = "http://localhost:8989";
          }
          {
            name = "sonarr.gmktec.local";
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
            name = "cockpit.gmktec.local";
            proxyPass = "http://localhost:9090";
          }
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

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."vm.swappiness" = 10;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;
  systemd.services.transmission.serviceConfig.BindPaths = ["/mnt"];
  services.cron = {
    enable = true;
    systemCronJobs = ["0 4 * * * root find /mnt/random/ -type f -mtime +3 -delete"];
  };
}
