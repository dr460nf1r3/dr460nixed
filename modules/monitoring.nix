{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.dr460nixed;
  adguardExporter = builtins.fetchurl {
    url = "https://github.com/ebrianne/adguard-exporter/releases/latest/download/adguard_exporter-linux-arm64";
    sha256 = "sha256:0y2gyw1xc366a70sblpjybl7alx70ppjzi5s4zzbm7swsa5vqqds";
  };
in
{
  options.dr460nixed = {
    grafanaStack = {
      enable = mkOption
        {
          default = false;
          type = types.bool;
          description = mdDoc ''
            Enables the Grafana stack (Grafana, Prometheus and Loki).
          '';
        };
      address = mkOption
        {
          default = "";
          type = types.str;
          description = mdDoc ''
            The address of the Grafana frontend.
          '';
        };
    };
    prometheus = {
      adguardExporter = {
        enable = mkOption
          {
            default = false;
            type = types.bool;
            description = mdDoc ''
              Enables Prometheus' AdGuard home exporter.
            '';
          };
        configfile = mkOption
          {
            default = "";
            type = types.str;
            description = mdDoc ''
              The path to the AdGuard home exporter config file.
            '';
          };
      };
      blackboxExporter = mkOption
        {
          default = false;
          type = types.bool;
          description = mdDoc ''
            Enables Prometheus' blackbox exporter.
          '';
        };
      enable = mkOption
        {
          default = true;
          type = types.bool;
          description = mdDoc ''
            Enables Prometheus' node_exporter.
          '';
        };
      nginxExporter = mkOption
        {
          default = false;
          type = types.bool;
          description = mdDoc ''
            Enables Prometheus' Nginx exporter.
          '';
        };
    };
    promtail = {
      enable = mkOption
        {
          default = true;
          type = types.bool;
          description = mdDoc ''
            Enables shipping systemd journal logs to Loki.
          '';
        };
      lokiAddress = mkOption
        {
          default = "";
          type = types.str;
          description = mdDoc ''
            The address of the Loki frontend.
          '';
        };
    };
  };

  config = {
    services.prometheus = {
      port = 3020;
      enable = mkIf cfg.grafanaStack.enable true;

      exporters = mkIf cfg.prometheus.enable {
        blackbox = mkIf cfg.prometheus.blackboxExporter {
          enable = true;
          port = 9115;
          configFile = "/var/lib/prometheus/blackbox.yml";
        };
        node = {
          port = 3021;
          enabledCollectors = [ "systemd" ];
          enable = true;
        };
        nginx = mkIf cfg.prometheus.nginxExporter {
          enable = true;
        };
      };

      # ingest the published nodes
      scrapeConfigs = [
        {
          job_name = "nodes";
          static_configs = [{
            targets = [
              "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
              "100.97.58.140:${toString config.services.prometheus.exporters.node.port}"
            ];
          }];
        }
        {
          job_name = "adguard";
          static_configs = [{
            targets = [
              "127.0.0.1:9617"
            ];
          }];
        }
        {
          job_name = "loki";
          static_configs = [{
            targets = [
              "${cfg.grafanaStack.address}:8030"
            ];
          }];
        }
        {
          job_name = "prometheus";
          static_configs = [{
            targets = [
              "127.0.0.1:9113"
            ];
          }];
        }
      ];
    };

    # Loki for system logs
    services.loki = mkIf cfg.grafanaStack.enable {
      enable = true;
      configuration = {
        auth_enabled = false;
        ingester = {
          chunk_idle_period = "1h";
          chunk_retain_period = "30s";
          chunk_target_size = 999999;
          lifecycler = {
            address = "${cfg.grafanaStack.address}";
            ring = {
              kvstore = {
                store = "inmemory";
              };
              replication_factor = 1;
            };
          };
          max_chunk_age = "24h";
        };
        schema_config = {
          configs = [{
            from = "2022-06-06";
            store = "boltdb-shipper";
            object_store = "filesystem";
            schema = "v11";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }];
        };
        server.http_listen_port = 3030;
        storage_config = {
          boltdb_shipper = {
            active_index_directory = "/var/lib/loki/boltdb-shipper-active";
            cache_location = "/var/lib/loki/boltdb-shipper-cache";
            cache_ttl = "24h";
            shared_store = "filesystem";
          };
          filesystem = {
            directory = "/var/lib/loki/chunks";
          };
        };
        limits_config = {
          ingestion_burst_size_mb = 512;
          ingestion_rate_mb = 1024;
          reject_old_samples = true;
          reject_old_samples_max_age = "168h";
        };
        chunk_store_config = {
          max_look_back_period = "0s";
        };
        table_manager = {
          retention_deletes_enabled = false;
          retention_period = "0s";
        };
        compactor = {
          working_directory = "/var/lib/loki";
          shared_store = "filesystem";
          compactor_ring = {
            kvstore = {
              store = "inmemory";
            };
          };
        };
      };
    };

    # promtail: port 3031 (8031)
    #
    services.promtail = mkIf cfg.promtail.enable {
      enable = true;
      configuration = {
        server = {
          http_listen_port = 3031;
          grpc_listen_port = 0;
        };
        clients = [{
          url = "http://${config.dr460nixed.promtail.lokiAddress}:3030/loki/api/v1/push";
        }];
        scrape_configs = [{
          job_name = "journal";
          journal = {
            path = "/var/log/journal";
            max_age = "24h";
            labels = {
              job = "systemd-journal";
              host = "${config.networking.hostName}";
            };
          };
          relabel_configs = [
            {
              source_labels = [ "__journal__systemd_unit" ];
              target_label = "unit";
            }
            {
              source_labels = [ "__journal_syslog_identifier" ];
              target_label = "syslog_identifier";
            }
            {
              source_labels = [ "__journal_container_tag" ];
              target_label = "container_tag";
            }
            {
              source_labels = [ "__journal_namespace" ];
              target_label = "namespace";
            }
            {
              source_labels = [ "__journal_container_name" ];
              target_label = "container_name";
            }
            {
              source_labels = [ "__journal_image_name" ];
              target_label = "image_name";
            }
          ];
        }];
      };
    };

    # Grafana on port 3010 (8010)
    services.grafana = mkIf cfg.grafanaStack.enable {
      enable = true;
      provision = {
        enable = true;
        datasources.settings = {
          apiVersion = 1;
          datasources = [
            {
              access = "proxy";
              name = "Prometheus";
              type = "prometheus";
              url = "http://127.0.0.1:${toString config.services.prometheus.port}";
            }
            {
              access = "proxy";
              name = "Loki";
              type = "loki";
              url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
            }
          ];
        };
      };
      settings = {
        analytics.reporting_enabled = false;
        live = {
          allowed_origins = [ "http://${config.dr460nixed.grafanaStack.address}:8010" ]; # Needed to get WS to work
        };
        security.admin_email = "root@dr460nf1r3.org";
        server = {
          http_addr = "127.0.0.1";
          http_port = 3010;
          protocol = "http";
          rootUrl = "http://${config.dr460nixed.grafanaStack.address}:8010";
        };
      };
    };

    # Also enable promtail on the Grafana host
    dr460nixed.promtail.enable = mkIf cfg.grafanaStack.enable true;

    # Nginx reverse proxy
    services.nginx = mkIf cfg.grafanaStack.enable {
      enable = true;
      upstreams = {
        "grafana" = {
          servers = {
            "127.0.0.1:${toString config.services.grafana.settings.server.http_port}" = { };
          };
        };
        "prometheus" = {
          servers = {
            "${config.dr460nixed.grafanaStack.address}:${toString config.services.prometheus.port}" = { };
          };
        };
        "loki" = {
          servers = {
            "127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}" = { };
          };
        };
        "promtail" = {
          servers = {
            "127.0.0.1:${toString config.services.promtail.configuration.server.http_listen_port}" = { };
          };
        };
      };
      virtualHosts.grafana = {
        locations."/" = {
          proxyPass = "http://grafana";
          extraConfig = ''
            proxy_set_header Host $host;
          '';
        };
        locations."/api/live/" = {
          proxyPass = "http://grafana";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
          '';
        };
        listen = [{
          addr = "${config.dr460nixed.grafanaStack.address}";
          port = 8010;
        }];
      };
      virtualHosts.prometheus = {
        locations."/".proxyPass = "http://prometheus";
        listen = [{
          addr = "${config.dr460nixed.grafanaStack.address}";
          port = 8020;
        }];
      };
      virtualHosts.loki = {
        locations."/".proxyPass = "http://loki";
        listen = [{
          addr = "${config.dr460nixed.grafanaStack.address}";
          port = 8030;
        }];
      };
      virtualHosts.promtail = {
        locations."/".proxyPass = "http://promtail";
        listen = [{
          addr = "${config.dr460nixed.grafanaStack.address}";
          port = 8031;
        }];
      };
    };
  };
}
