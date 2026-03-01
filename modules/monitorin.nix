{
  config,
  pkgs,
  lib,
  ...
}: {
  services.prometheus = {
    enable = true;
    port = 9090;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
        port = 9100;
      };
    };
    scrapeConfigs = [
      {
        job_name = "nixos-nodes";
        static_configs = [
          {
            targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
          }
        ];
      }
    ];
  };

  # Loki Service (Storage)
  services.loki = {
    enable = true;
    configuration = {
      compactor = {
        working_directory = "/var/lib/loki/compactor";
        delete_request_store = "filesystem";
        compaction_interval = "10m";
        retention_enabled = true;
        retention_delete_delay = "2h";
        retention_delete_worker_count = 150;
      };

      # 2. Define the limits
      limits_config = {
        retention_period = "96h"; # 4 days
        ingestion_rate_mb = 10;
        ingestion_burst_size_mb = 20;
        volume_enabled = true;
      };

      auth_enabled = false;
      server.http_listen_port = 3100;
      common = {
        instance_addr = "127.0.0.1";
        path_prefix = "/var/lib/loki";
        replication_factor = 1;
        storage.filesystem = {
          chunks_directory = "/var/lib/loki/chunks";
          rules_directory = "/var/lib/loki/rules";
        };
        ring = {
          kvstore.store = "memberlist";
        };
      };

      memberlist = {
        join_members = ["127.0.0.1"];
      };

      ingester.lifecycler.ring.kvstore.store = "memberlist";

      schema_config.configs = [
        {
          from = "2024-01-01"; # Update to a relevant date
          store = "tsdb";
          object_store = "filesystem";
          schema = "v13";
          index = {
            prefix = "index_";
            period = "24h";
          };
        }
      ];
    };
  };
  users.users.promtail.extraGroups = ["adm" "nginx" "pihole" "unifi"];

  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 28183;
        grpc_listen_port = 0;
      };
      clients = [{url = "http://127.0.0.1:3100/loki/api/v1/push";}];
      scrape_configs = [
        {
          job_name = "local_system_logs";
          static_configs = [
            {
              targets = ["localhost"];
              labels = {
                job = "varlogs";
                host = "nixos-box";
                __path__ = "/var/log/**/*.log";
              };
            }
          ];
        }
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = "nixos-box";
            };
          };
          relabel_configs = [
            {
              source_labels = ["__journal__systemd_unit"];
              target_label = "unit";
            }
          ];
        }
      ];
    };
  };
  systemd.tmpfiles.rules = [
    "L+ /etc/grafana-dashboards/node-exporter.json - - - - ${../1860_rev42.json}"
  ];
  services.grafana = {
    enable = true;
    settings.server = {
      http_addr = "127.0.0.1";
      http_port = 3000;
    };
    provision = {
      enable = true;
      dashboards.settings.providers = [
        {
          name = "My Dashboards";
          options.path = "/etc/grafana-dashboards";
        }
      ];
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://127.0.0.1:9090";
        }
        {
          name = "Loki";
          type = "loki";
          url = "http://127.0.0.1:3100";
        }
      ];
    };
  };
}
