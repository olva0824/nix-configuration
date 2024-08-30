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
      url = "github:nix-community/nixvim";
      # url = "github:nix-community/nixvim/nixos-24.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    nixvim,
    home-manager,
  }: let
    configuration = {pkgs, ...}: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
        vim
        go
        zig
        fzf
        ripgrep
        delve #debug adapter for golang
        kubectl
        k9s
        git
        lazygit
        lazydocker
        golangci-lint
        hoppscotch
        tmuxPlugins.resurrect
        tmuxPlugins.weather
        tmuxPlugins.cpu
        dbeaver-bin
        buf
        cargo
        rustc
        protobuf_27
        protoc-gen-go
        statix
        protoc-gen-js
        pulumi
        bun
        nodejs_22
        # (pkgs.rustPlatform.buildRustPackage rec {  looks like it taking flit sources
        #   pname = "protols";
        #   version = "0.5.0";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "coder3101";
        #     repo = "protols";
        #     rev = "993120b7ea68f015db8bef6912dbc8bb9098504e";
        #     hash = "sha256-lLlad/kbrjwPE8ZdzebJMhA06AqpmEI+PJCWz12LYRM=";
        #   };
        #   cargoSha256 = "03wf9r2csi6jpa7v5sw5lpxkrk4wfzwmzx7k3991q3bdjzcwnnwp";
        #   cargoLock = {
        #     lockFile = "${src}/Cargo.lock";
        #     # allowBuiltinFetchGit = true;
        #   };
        # })
      ];
      imports = [
        nixvim.nixDarwinModules.nixvim
        ./nvim
      ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      programs = {
        tmux = {
          enable = true;

          # plugins = with pkgs; [
          #   tmuxPlugins.better-mouse-mode
          # ];
          extraConfig = ''
            # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
            set -g default-terminal "xterm-256color"
            set -ga terminal-overrides ",*256col*:Tc"
            set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
            set-environment -g COLORTERM "truecolor"

            # Mouse works as expected
            set-option -g mouse on
            # easy-to-remember split pane commands
            #bind | split-window -h -c "#{pane_current_path}"
            #bind - split-window -v -c "#{pane_current_path}"
            #bind c new-window -c "#{pane_current_path}"
          '';
        };
        zsh.enable = true;
        nixvim.enable = true;
      };
      fonts.packages = with pkgs; [
        (nerdfonts.override {fonts = ["Mononoki"];})
      ];
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
      };
      #
      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # homebrew.enable = true;
      # homebrew.casks = [
      #   "zed"
      # ];
      # homebrew.brews = [
      # ];
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#cmadmins-MacBook-Pro
    darwinConfigurations."cmadmins-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [configuration];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."cmadmins-MacBook-Pro".pkgs;
  };
}
