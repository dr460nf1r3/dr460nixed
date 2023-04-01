{pkgs, ...}: {
  # Thunderbird configuration
  programs.thunderbird = {
    enable = true;
    profiles."nico" = {
      isDefault = true;
      settings = {
        "datareporting.healthreport.uploadEnabled" = false;
        "font.name.sans-serif.x-western" = "Fira Sans";
        "mail.incorporate.return_receipt" = 1;
        "mail.markAsReadOnSpam" = true;
        "mail.spam.logging.enabled" = true;
        "mail.spam.manualMark" = true;
        "offline.download.download_messages" = 1;
        "offline.send.unsent_messages" = 1;
      };
    };
  };

  # Basic Firefox settings (user)
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "Nico";
      # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      #   darkreader
      #   flagfox
      #   grammarly
      #   gsconnect
      #   libredirect
      #   localcdn
      #   privacy-pass
      #   tabliss
      #   ublock-origin
      # ];
      extraConfig = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/dr460nf1r3/firedragon-browser/master/firedragon.cfg";
        sha256 = "sha256:0s81cabb4d3cvbqk4cymq5bcxx816dsdfx10lmb4wywd1m2vx1wd";
      };
      isDefault = true;
      search.engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@np"];
        };
        "NixOS Wiki" = {
          urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = ["@nw"];
        };
        "Whoogle" = {
          urls = [{template = "https://search.dr460nf1r3.org?search={searchTerms}";}];
          iconUpdateURL = "https://search.dr460nf1r3.org/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = ["@w"];
        };
        "Amazon.com".metaData.hidden = true;
        "Bing".metaData.hidden = true;
        "Google".metaData.hidden = true;
        "eBay".metaData.hidden = true;
      };
    };
  };

  # Basic Chromium settings using Ungoogled Chromium (user)
  programs.chromium = {
    commandLineArgs = [
      "--enable-accelerated-2d-canvas"
      "--enable-features=VaapiVideoDecoder"
      "--enable-features=WebUIDarkMode"
      "--enable-gpu-rasterization"
      "--enable-vulkan"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"
      "--ozone-platform-hint=auto"
    ];
    enable = true;
    extensions = [
      {
        id = "oladmjdebphlnjjcnomfhhbfdldiimaf";
        updateUrl = "https://raw.githubusercontent.com/libredirect/libredirect/master/src/updates/updates.xml";
      }
    ];
  };
}
