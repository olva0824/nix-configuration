{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:olva0503/olva-nixvim";
    };
  };

  outputs = {
    self,
    nix-darwin,
    nixpkgs,
    nixvim,
    home-manager,
  } @ inputs: let
    configuration = {pkgs, ...}: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
        gemini-cli
        zig
        fzf
        ripgrep
        kubectl
        k9s
        git
        lazygit
        libiconv
        (
          python313.withPackages (python-pkgs:
            with python-pkgs; [
              # select Python packages here
              pip
            ])
        )
        ###go
        golangci-lint
        # go
        ngrok
        go_1_23
        gofumpt
        delve #debug adapter for golang
        #
        mermaid-cli
        buf
        cargo
        rustc
        # protobuf_27
        # protoc-gen-go
        statix
        # ollama
        atuin
        btop
        bat
        bun
        nodejs_22
        sqlfluff
        mprocs
        bunyan-rs
        trivy
        _1password-cli
        yazi
        protols
        hurl
        evil-helix
        (nixvim.lib.makeNixvimWithExtra system ./nvim/project-specifix.nix)
      ];

      nixpkgs.config.allowUnfree = true;

      users.users.user = {
        #   name = "owla";
        home = "/Users/user";
      };

      imports = [
        # nixvim.nixDarwinModules.nixvim
        # ./nvim
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            users = {
              user = import ./home.nix;
            };
            useGlobalPkgs = true;
            useUserPackages = true;
          };
        }
      ];

      nix.enable = true;
      # Auto upgrade nix package and the daemon service.
      programs = {
        zsh = {
          enable = true;
        };

        # nixvim.enable = true;
      };
      fonts.packages = with pkgs; [
        nerd-fonts.mononoki
      ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      # programs.fish.enable = true;
      ids.uids.nixbld = 350;
      # Set Git commit hash for darwin-version.
      system = {
        defaults = {
          dock = {
            mru-spaces = false;
            autohide = true;
          };
        };
        primaryUser = "user";
        stateVersion = 4;
        configurationRevision = self.rev or self.dirtyRev or null;
      };

      #
      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#cmadmins-MacBook-Pro
    #darwinConfigurations."cmadmins-MacBook-Pro" = nix-darwin.lib.darwinSystem {
    #  modules = [configuration];
    #};
    darwinConfigurations.MacBook-Pro = nix-darwin.lib.darwinSystem {
      modules = [configuration];
    };
    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MacBook-Pro".pkgs;
  };
}
