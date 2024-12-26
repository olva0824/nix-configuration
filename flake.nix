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
        gofumpt
        zig
        fzf
        ripgrep
        delve #debug adapter for golang
        kubectl
        k9s
        git
        redli
        lazygit
        libiconv
        (
          python313.withPackages (python-pkgs:
            with python-pkgs; [
              # select Python packages here
              pip
            ])
        )
        lazydocker
        golangci-lint
        d2
        mermaid-cli
        hoppscotch
        tmux
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
        pulumi-bin
        ollama
        atuin
        btop
        bat
        bun
        nodejs_22
        # (pkgs.rustPlatform.buildRustPackage rec {  looks like it taking flit sources
        #   pname = "protols";
        #   version = "0.6.0";
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
          # plugins = with pkgs; [
          #   tmuxPlugins.resurrect
          #   tmuxPlugins.weather
          #   tmuxPlugins.cpu
          #   tmuxPlugins.better-mouse-mode
          # ];
          extraConfig = ''
            resurrect_dir=${pkgs.tmuxPlugins.cpu}
            set -g @resurrect-dir $resurrect_dir
            set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/home/$USER/.nix-profile/bin/||g" $target | sponge $target'
            # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
            set -g default-terminal "xterm-256color"
            set -ga terminal-overrides ",*256col*:Tc"
            set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'

            set -gq allow-passthrough on

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
        nerd-fonts.mononoki
      ];
      # nix.package = pkgs.nix;

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
        stateVersion = 4;
        configurationRevision = self.rev or self.dirtyRev or null;
      };

      #
      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog

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
