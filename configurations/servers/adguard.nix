{
  config,
  lib,
  ...
}: {
  # Own systemd config using a custom user
  systemd.services.adguardhome = {
    serviceConfig.User = "adguard";
    serviceConfig.Group = "adguard";
    serviceConfig.DynamicUser = lib.mkForce false;
  };

  # The custom adguard user & group
  users.users."adguard" = {
    group = "adguard";
    extraGroups = ["nginx"];
    home = "/var/lib/AdGuardHome";
    description = "Adguard DNS";
    createHome = false;
    isSystemUser = true;
  };
  users.groups.adguard = {};

  # Complete Adguard configuration
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    settings = {
      bind_host = "127.0.0.1";
      bind_port = 3000;
      users = [
        {
          name = "nico";
          password = "$2b$05$zjtZ461DmcgZTgv7AppSOu66ZieCWEAR63xCeGQt.CyKJYAzhkK82";
        }
      ];
      auth_attempts = 5;
      block_auth_min = 15;
      dns = {
        bind_hosts = ["10.241.1.3"];
        port = 53;
        statistics_interval = 90;
        querylog_enabled = true;
        querylog_file_enabled = true;
        querylog_interval = "2160h";
        querylog_size_memory = 1000;
        anonymize_client_ip = false;
        protection_enabled = true;
        blocking_mode = "default";
        blocking_ipv4 = "";
        blocking_ipv6 = "";
        blocked_response_ttl = 10;
        parental_block_host = "family-block.dns.adguard.com";
        safebrowsing_block_host = "standard-block.dns.adguard.com";
        ratelimit = 20;
        ratelimit_whitelist = [];
        refuse_any = true;
        upstream_dns = ["https://cloudflare-dns.com/dns-query"];
        upstream_dns_file = "";
        bootstrap_dns = [
          "1.1.1.1"
          "1.0.0.1"
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
        ];
        all_servers = false;
        fastest_addr = false;
        fastest_timeout = "1s";
        allowed_clients = [
          "10.241.1.1"
          "10.241.1.2"
          "10.241.1.3"
          "10.241.1.4"
          "10.241.1.5"
          "127.0.0.1"
        ];
        disallowed_clients = [];
        blocked_hosts = [
          "hostname.bind"
        ];
        trusted_proxies = [
          "127.0.0.1"
        ];
        cache_size = 4194304;
        cache_ttl_min = 0;
        cache_ttl_max = 0;
        cache_optimistic = true;
        bogus_nxdomain = [];
        aaaa_disabled = false;
        enable_dnssec = true;
        edns_client_subnet = false;
        max_goroutines = 300;
        ipset = [];
        filtering_enabled = true;
        filters_update_interval = 1;
        parental_enabled = false;
        safesearch_enabled = false;
        safebrowsing_enabled = false;
        safebrowsing_cache_size = 1048576;
        safesearch_cache_size = 1048576;
        parental_cache_size = 1048576;
        cache_time = 30;
        rewrites = [];
        blocked_services = [
          "facebook"
          "instagram"
          "skype"
          "snapchat"
          "tiktok"
          "twitch"
          "twitter"
          "whatsapp"
        ];
        upstream_timeout = "10s";
        private_networks = [];
        use_private_ptr_resolvers = true;
        local_ptr_upstreams = [];
        dns64_prefixes = [];
        serve_http3 = false;
        use_http3_upstreams = true;
      };
      querylog = {
        enabled = true;
        file_enabled = true;
        interval = "2160h";
        size_memory = 1000;
        ignored = [];
      };
      statistics = {
        enabled = true;
        interval = 90;
        ignored = [];
      };
      filters = [
        {
          # AdGuard Base filter, Social media filter, Spyware filter, Mobile ads filter, EasyList and EasyPrivacy
          enabled = true;
          url = "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt";
          name = "AdGuard DNS filter";
          id = 1;
        }
        {
          # AdAway default blocklist
          enabled = true;
          url = "https://adaway.org/hosts.txt";
          name = "AdAway Default Blocklist";
          id = 2;
        }
        {
          # Dedicated no-tracking list
          enabled = true;
          url = "https://github.com/notracking/hosts-blocklists/raw/master/adblock/adblock.txt";
          name = "Anti-Tracking";
          id = 3;
        }
        {
          # Firehol Level 1 blocklist)
          enabled = true;
          url = "https://iplists.firehol.org/files/firehol_level1.netset";
          name = "Firehol Level 1";
          id = 4;
        }
        {
          # Personal blocklist of Hazegi (mixing lots of popular blocklists)
          enabled = true;
          url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/personal.txt";
          name = "HaGeZi Personal Blocklist";
          id = 5;
        }
        {
          enabled = true;
          url = "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt";
          name = "WindowsSpyBlocker";
          id = 6;
        }
        {
          enabled = true;
          url = "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/android-tracking.txt";
          name = "Android Tracking";
          id = 7;
        }
      ];
      tls = {
        enabled = true;
        server_name = "10.241.1.3";
        force_https = false;
        port_https = 3001;
        port_dns_over_tls = 853;
        port_dns_over_quic = 853;
        allow_unencrypted_doh = true;
        certificate_path = config.sops.secrets."ssl/home-dragon-cert".path;
        private_key_path = config.sops.secrets."ssl/home-dragon-key".path;
      };
      schema_version = 14;
    };
  };
}
