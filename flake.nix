{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-unstable";
    # lix = {
    #   url = "git+https://git.lix.systems/lix-project/lix/src/commit/10ac99a79c789dad2d5b40101ffd41a5c7ef9622";
    #   flake = false;
    # };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.lix.follows = "lix";
    };
    nur.url = "github:nix-community/NUR";
    anyrun-nixos-options = {
      url = "github:n3oney/anyrun-nixos-options";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    arkenfox-firefox-userjs = {
      url = "github:dwarfmaster/arkenfox-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-cursors = {
      url = "github:catppuccin/cursors";
    };
    # ags = {
    #   url = "github:Aylur/ags";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    tokyonightNur = {
      url = "github:AtaraxiaSjel/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    arrpc = {
      url = "github:notashelf/arrpc-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      # url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=e4e84064f2d07810e0c150bce1369a0a00503e9a";
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypr-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impurity = {
      url = "github:outfoxxed/impurity.nix";
    };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Rust overlay
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Nil - Nix LSP
    nix-nil-lsp = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    nix-nixd-lsp = {
      url = "github:nix-community/nixd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun = {
      # url = "github:anyrun-org/anyrun/3c2e38ea65bf85a3afcceb24ffa4787ba0c22da5";

      url = "github:anyrun-org/anyrun/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xdph = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-nightly = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # A TUI file manager
    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    impurity,
    lix-module,
    ...
  }: let
    overlays = [
      inputs.nur.overlay
      inputs.rust-overlay.overlays.default
      inputs.neovim-nightly-overlay.overlays.default
    ];
    pkgs = import nixpkgs {
      inherit overlays;
      config.allowUnfree = true;
      # localSystem = {
      #   gcc.arch = "znver2";
      #   gcc.tune = "znver2";
      #   system = "x86_64-linux";
      #   features = ["gccarch-znver2"];
      # };
    };
  in {
    nixosConfigurations = {
      formatter = "alejandra";
      omen = nixpkgs.lib.nixosSystem rec {
        pkgs = import nixpkgs {
          inherit overlays;
          config.allowUnfree = true;
          # localSystem = {
          #   gcc.arch = "znver2";
          #   gcc.tune = "znver2";
          #   system = "x86_64-linux";
          #   features = ["gccarch-znver2"];
          # };
        };
        system = "x86_64-linux";
        specialArgs = {inherit self system inputs;};
        modules = [
          lix-module.nixosModules.default
          ./configuration.nix
          # {
          #   imports = [impurity.nixosModules.impurity];
          #   impurity.configRoot = self;
          # }
          {
            programs.nh = {
              package = inputs.nh.packages.${system}.default;
              enable = true;
              clean.enable = true;
              clean.extraArgs = "--keep-since 4d --keep 3";
            };
          }
          home-manager.nixosModules.home-manager
          ({...}: {
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.prometheus = import ./home;
          })
        ];
      };
      # omen-impure =
      #   self.nixosConfigurations.omen.extendModules
      #   {
      #     modules = [
      #       {impurity.enable = true;}
      #     ];
      #   };
    };
  };
}
