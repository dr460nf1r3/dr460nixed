{ config
, lib
, ...
}: {
  # Own systemd config using a custom user
  systemd.services.adguardhome = {
    serviceConfig.DynamicUser = lib.mkForce false;
    serviceConfig.Group = "adguard";
    serviceConfig.User = "adguard";
  };

  # The custom adguard user & group
  users.users."adguard" = {
    createHome = false;
    description = "Adguard DNS";
    extraGroups = [ "nginx" ];
    group = "adguard";
    home = "/var/lib/AdGuardHome";
    isSystemUser = true;
  };
  users.groups.adguard = { };

  # Complete Adguard configuration
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    settings = {
      auth_attempts = 5;
      bind_host = "127.0.0.1";
      bind_port = 3000;
      block_auth_min = 15;
      dns = {
        aaaa_disabled = false;
        all_servers = false;
        allowed_clients = [ ];
        anonymize_client_ip = false;
        bind_hosts = [
          "100.86.102.115"
          "fd7a:115c:a1e0:ab12:4843:cd96:6256:6673"
        ];
        blocked_hosts = [
          "hostname.bind"
        ];
        blocked_response_ttl = 10;
        blocking_ipv4 = "";
        blocking_ipv6 = "";
        blocking_mode = "default";
        blocked_services = [
          "facebook"
          "instagram"
          "skype"
          "snapchat"
          "tiktok"
          "twitch"
          "whatsapp"
        ];
        bogus_nxdomain = [ ];
        bootstrap_dns = [
          "1.1.1.1"
          "1.0.0.1"
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
        ];
        cache_optimistic = true;
        cache_size = 4194304;
        cache_time = 30;
        cache_ttl_max = 0;
        cache_ttl_min = 0;
        disallowed_clients = [ ];
        dns64_prefixes = [ ];
        enable_dnssec = true;
        fastest_addr = false;
        fastest_timeout = "1s";
        filtering_enabled = true;
        filters_update_interval = 1;
        ipset = [ ];
        local_ptr_upstreams = [ ];
        max_goroutines = 300;
        parental_block_host = "family-block.dns.adguard.com";
        parental_cache_size = 1048576;
        parental_enabled = false;
        port = 53;
        private_networks = [ ];
        protection_enabled = true;
        querylog_enabled = true;
        querylog_file_enabled = true;
        querylog_interval = "2160h";
        querylog_size_memory = 1000;
        ratelimit = 20;
        ratelimit_whitelist = [ ];
        refuse_any = true;
        rewrites = [ ];
        safebrowsing_block_host = "standard-block.dns.adguard.com";
        safebrowsing_cache_size = 1048576;
        safebrowsing_enabled = false;
        safesearch_cache_size = 1048576;
        safesearch_enabled = false;
        serve_http3 = true;
        statistics_interval = 90;
        trusted_proxies = [
          "127.0.0.1"
        ];
        upstream_dns = [ "https://cloudflare-dns.com/dns-query" ];
        upstream_dns_file = "";
        upstream_timeout = "10s";
        use_http3_upstreams = true;
        use_private_ptr_resolvers = true;
      };
      querylog = {
        enabled = true;
        file_enabled = true;
        ignored = [ ];
        interval = "2160h";
        size_memory = 1000;
      };
      statistics = {
        enabled = true;
        ignored = [ ];
        interval = "2160h";
      };
      filters = [
        {
          # AdGuard Base filter, Social media filter, Spyware filter, Mobile ads filter, EasyList and EasyPrivacy
          enabled = true;
          id = 1;
          name = "AdGuard DNS filter";
          url = "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt";
        }
        {
          # AdAway default blocklist
          enabled = true;
          id = 2;
          name = "AdAway Default Blocklist";
          url = "https://adaway.org/hosts.txt";
        }
        {
          # Dedicated no-tracking list
          enabled = true;
          id = 3;
          name = "Anti-Tracking";
          url = "https://github.com/notracking/hosts-blocklists/raw/master/adblock/adblock.txt";
        }
        {
          # Firehol Level 1 blocklist)
          enabled = true;
          id = 4;
          name = "Firehol Level 1";
          url = "https://iplists.firehol.org/files/firehol_level1.netset";
        }
        {
          # Personal blocklist of Hazegi (mixing lots of popular blocklists)
          enabled = true;
          id = 5;
          name = "HaGeZi Personal Blocklist";
          url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/personal.txt";
        }
        {
          enabled = true;
          id = 6;
          name = "WindowsSpyBlocker";
          url = "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt";
        }
        {
          enabled = true;
          id = 7;
          name = "Android Tracking";
          url = "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/android-tracking.txt";
        }
      ];
      tls = {
        allow_unencrypted_doh = true;
        certificate_path = config.sops.secrets."ssl/oracle-dragon-cert".path;
        enabled = true;
        force_https = false;
        port_dns_over_quic = 853;
        port_dns_over_tls = 853;
        port_https = 3001;
        private_key_path = config.sops.secrets."ssl/oracle-dragon-key".path;
        server_name = "100.86.102.115";
      };
      users = [
        {
          name = "nico";
          password = "$2b$05$zjtZ461DmcgZTgv7AppSOu66ZieCWEAR63xCeGQt.CyKJYAzhkK82";
        }
      ];
      schema_version = 20;
    };
  };

  # Supply non-RDNS found hostnames via /etc/hosts
  networking.hosts = {
    "100.116.167.11" = [ "dragon-pixel" ];
    "100.120.171.12" = [ "tv-nixos" ];
    "100.85.210.126" = [ "rpi-dragon" ];
    "100.86.102.115" = [ "oracle-dragon" ];
    "100.99.129.81" = [ "slim-lair" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:6255:d27e" = [ "oracle-dragon" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:6256:6673" = [ "rpi-dragon" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:6263:8151" = [ "slim-lair" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:6274:a70b" = [ "dragon-pixel" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:6278:ab0c" = [ "tv-nixos" ];
  };
}
