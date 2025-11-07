{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixpkgs-unstable";
    # mpd-nixpkgs.url = "github:NixOS/nixpkgs/d38cf01b42c0c768de923c40fa9b6e112442835f";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.lix.follows = "lix";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun-nixos-options = {
      url = "github:n3oney/anyrun-nixos-options";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    arkenfox-firefox-userjs = {
      url = "github:dwarfmaster/arkenfox-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
    };
    catppuccin.url = "github:catppuccin/nix";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      # THIS IS IMPORTANT
      # Mismatched system dependencies will lead to crashes and other issues.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tokyonightNur = {
      url = "github:AtaraxiaSjel/nur/f76d325552b69f7cacff4e9f86ecad5586844050";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    # hy3 = {
    #   url = "github:outfoxxed/hy3";
    #   inputs.hyprland.follows = "hyprland";
    # };
    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
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
      url = "github:hyprwm/Hyprland";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # impurity = {
    #   url = "github:outfoxxed/impurity.nix";
    # };
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
    };
    nix-nixd-lsp = {
      url = "github:nix-community/nixd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun = {
      url = "github:anyrun-org/anyrun/c787318f590102b68fbd2e5b02ea47e96f4ecb62";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprutils = {
      url = "github:hyprwm/hyprutils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-nightly = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # A TUI file manageri
    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    # impurity,
    # lix-module,
    catppuccin,
    nix-index-database,
    ...
  }: let
    # system = "x86_64-linux";
    overlays = [
      inputs.nur.overlays.default
      inputs.rust-overlay.overlays.default
      inputs.neovim-nightly-overlay.overlays.default
      # (import ./dmraid-overlay.nix)
      # (self: super: (let
      #   mypkgs = import inputs.mpd-nixpkgs {
      #     system = system;
      #   };
      # in {
      #   mpd = mypkgs.mpd;
      # }))
    ];
    pkgs = import nixpkgs {
      inherit overlays;
      system = "x86_64-linux";
      config.allowUnfree = true;
      config.allowUnfreePredicate = _: true;
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
        inherit pkgs;
        system = "x86_64-linux";
        specialArgs = {inherit self system inputs;};
        modules = [
          catppuccin.nixosModules.catppuccin
          nix-index-database.nixosModules.nix-index
          ./configuration.nix
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
            home-manager.users.prometheus = {imports = [./home catppuccin.homeModules.catppuccin];};
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
