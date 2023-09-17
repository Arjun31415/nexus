{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixpkgs-unstable";
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    hypr-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impurity = {
      url = "github:outfoxxed/impurity.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mpd-mpris = {
      url = "github:natsukagami/mpd-mpris";
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
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xdg-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    impurity,
    ...
  }: {
    nixosConfigurations = {
      omen = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        formatter = "alejandra";
        specialArgs = {inherit self system inputs;};
        modules = [
          ./configuration.nix
          {
            imports = [impurity.nixosModules.impurity];
            impurity.configRoot = self;
          }
          home-manager.nixosModules.home-manager
          ({impurity, ...}: {
            home-manager.extraSpecialArgs = {inherit inputs impurity;};
            #            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.prometheus = import ./home;
          })
        ];
      };
      omen-impure =
        self.nixosConfigurations.omen.extendModules
        {
          modules = [
            {impurity.enable = true;}
          ];
        };
    };
  };
}
