{
  description = "NixOS configuration";

  inputs = {
    ags.url = "github:Aylur/ags";

    tokyonightNur.url = "github:AtaraxiaSjel/nur";
    nixpkgs.url = "github:notashelf/nixpkgs";
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
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:the-argus/spicetify-nix";
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
    nixpkgs,
    home-manager,
    ...
  }: {
    formatter = "alejandra";
    nixosConfigurations = {
      omen = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {inherit inputs;};
            #            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.prometheus = import ./home;
          }
        ];
      };
    };
  };
}
