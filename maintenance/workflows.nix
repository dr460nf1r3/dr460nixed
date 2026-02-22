_: {
  githubActions = {
    enable = true;
    workflows = {
      create_release = {
        name = "Create release";
        concurrency = {
          group = "\${{ github.workflow }}";
          cancelInProgress = true;
        };
        permissions.contents = "write";
        on.push.tags = [ "*" ];
        jobs.build-iso = {
          runsOn = "ubuntu-latest";
          steps = [
            {
              name = "Free disk space";
              run = "sudo rm -rf /usr/share /usr/local /opt || true";
            }
            {
              name = "Checkout";
              uses = "actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd";
            }
            {
              name = "Install Nix";
              uses = "DeterminateSystems/nix-installer-action@v21";
              with_ = {
                extra-conf = ''
                  accept-flake-config = true
                  system-features = big-parallel kvm
                '';
                diagnostic-endpoint = "";
              };
            }
            {
              name = "Build ISO";
              run = ''
                nix run -L .#iso
                ISO_NAME=$(realpath result | cut -d "/" -f6)
                cp result "$ISO_NAME"
              '';
              env = {
                NIXPKGS_ALLOW_UNFREE = "1";
              };
            }
            {
              name = "Split ISO";
              run = "split -b 1990M -a 1 --numeric-suffixes=1 ./*.iso \"dr460nixed-desktop.iso.part-\"";
            }
            {
              name = "Create release";
              uses = "softprops/action-gh-release@v2";
              with_ = {
                body_path = "CHANGELOG.md";
                fail_on_unmatched_files = true;
                files = "dr460nixed-desktop.iso.part-*";
                token = "\${{ secrets.GITHUB_TOKEN }}";
              };
            }
          ];
        };
      };
      pages = {
        name = "Cloudflare pages";
        on.push = {
          branches = [ "main" ];
          paths = [
            "docs/**"
            ".github/workflows/pages.yml"
          ];
        };
        permissions.contents = "write";
        jobs.build-and-deploy = {
          concurrency = "ci-\${{ github.ref }}";
          runsOn = "ubuntu-latest";
          steps = [
            {
              name = "Checkout";
              uses = "actions/checkout@v6";
            }
            {
              name = "Setup mdBook";
              uses = "peaceiris/actions-mdbook@v2";
              with_ = {
                mdbook-version = "latest";
              };
            }
            {
              name = "Install further deps";
              run = ''
                sudo apt-get install -y --no-install-recommends cargo
                cargo install mdbook-admonish
                cargo install mdbook-emojicodes
                PATH=$HOME/.cargo/bin:$PATH
              '';
            }
            {
              name = "Install and Build";
              run = "cd docs && mdbook build";
            }
            {
              name = "Deploy";
              uses = "peaceiris/actions-gh-pages@v4";
              with_ = {
                github_token = "\${{ secrets.GITHUB_TOKEN }}";
                publish_branch = "cf-pages";
                publish_dir = "docs/book";
              };
            }
          ];
        };
      };
      tailscale = {
        name = "Sync Tailscale ACLs";
        on.push = {
          branches = [ "main" ];
          paths = [ "policy.hujson" ];
        };
        jobs.acls = {
          runsOn = "ubuntu-latest";
          steps = [
            {
              name = "Checkout";
              uses = "actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd";
            }
            {
              name = "Deploy ACL";
              if_ = "github.event_name == 'push'";
              id = "deploy-acl";
              uses = "tailscale/gitops-acl-action@v1";
              with_ = {
                action = "apply";
                api-key = "\${{ secrets.TS_API_KEY }}";
                tailnet = "\${{ secrets.TS_TAILNET }}";
              };
            }
            {
              name = "Test ACL";
              if_ = "github.event_name == 'pull_request'";
              id = "test-acl";
              uses = "tailscale/gitops-acl-action@v1";
              with_ = {
                action = "test";
                api-key = "\${{ secrets.TS_API_KEY }}";
                tailnet = "\${{ secrets.TS_TAILNET }}";
              };
            }
          ];
        };
      };
    };
  };
}
