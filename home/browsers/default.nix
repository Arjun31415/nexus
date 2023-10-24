{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.arkenfox-firefox-userjs.hmModules.default];

  home.packages = [
    (inputs.wrapper-manager.lib.build
      {
        inherit pkgs;
        modules = [
          ./brave-x.nix
        ];
      })
  ];
  programs.chromium = {
    enable = true;
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
    ];
  };
  programs.firefox = {
    arkenfox = {
      enable = true;
      version = "103.0";
    };
    package = inputs.firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin.override {
      extraPolicies = {
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = true;
        FirefoxHome = {
          Pocket = false;
          Snippets = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
      extraPrefs = ''
        // Downloading random PDFs from http website is super annoing with this.
        lockPref("dom.block_download_insecure", false);

        // Always use XDG portals for stuff
        lockPref("widget.use-xdg-desktop-portal.file-picker", 1);

        // Avoid cluttering ~/Downloads for the “Open” action on a file to download.
        lockPref("browser.download.start_downloads_in_tmp_dir", true);
        // Show more ssl cert infos
        lockPref("security.identityblock.show_extended_validation", true);
      '';
    };
    enable = true;
    profiles = {
      personal = {
        arkenfox = {
          enable = true;
          "0000".enable = true;
          "0100".enable = true;
          "0200".enable = true;
        };
        id = 0;
        name = "personal";
        search = {
          force = true;
          default = "Searxng";
          engines = {
            "Searxng" = {
              urls = [
                {template = "https://search.notashelf.dev/?q={searchTerms}";}
              ];
              definedAliases = ["@sx"];
            };
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
            "Wikipedia (en)".metaData.alias = "@wiki";
            "Amazon.com".metaData.hidden = true;
            "Bing".metaData.hidden = true;
            "eBay".metaData.hidden = true;
          };
        };
        settings = {
          "general.smoothScroll" = true;
        };
        extraConfig = ''
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          user_pref("full-screen-api.ignore-widgets", true);
          user_pref("media.ffmpeg.vaapi.enabled", true);
          user_pref("media.rdd-vpx.enabled", true);
        '';

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          clearurls
        ];
      };
    };
  };
}
