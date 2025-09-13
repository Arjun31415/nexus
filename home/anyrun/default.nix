{
  inputs,
  pkgs,
  osConfig,
  lib,
  ...
}: let
  inherit (inputs) anyrun;
  anyrun_packages = anyrun.packages.${pkgs.system};
in {
  imports = [
    (
      {modulesPath, ...}: {
        disabledModules = ["${modulesPath}/programs/anyrun.nix"];
      }
    )
    anyrun.homeManagerModules.default
  ];
  programs.anyrun = {
    enable = true;
    config = {
      plugins = with anyrun_packages; [
        # An array of all the plugins you want, which either can be paths to the .so files, or their packages
        applications
        dictionary
        kidex
        rink
        shell
        stdin
        symbols
        translate
        websearch
      ];
      # ++ [inputs.anyrun-nixos-options.packages.${pkgs.system}.default];

      width = {absolute = 800;};
      layer = "overlay";
      height = {absolute = 0;};
      x = {fraction = 0.5;};
      y = {fraction = 0.5;};
      # verticalOffset = {absolute = 0;};
      # position = "top";

      hideIcons = false;
      ignoreExclusiveZones = false;
      closeOnClick = true;
      showResultsImmediately = false;
      hidePluginInfo = false;
      maxEntries = 10;
    };
    # extraCss = ''
    #   box#main {
    #     border-radius: 10px;
    #     background-color: @theme_bg_color;
    #   }
    #
    #   list#main {
    #     background-color: rgba(0, 0, 0, 0);
    #     border-radius: 10px;
    #   }
    #
    #   list#plugin {
    #     background-color: rgba(0, 0, 0, 0);
    #   }
    #
    #   label#match-desc {
    #     font-size: 10px;
    #   }
    #
    #   label#plugin {
    #     font-size: 14px;
    #   }
    # '';

    extraConfigFiles."dictionary.ron".text = ''
      Config(
        prefix: ":d",
      )
    '';
    extraConfigFiles."translate.ron".text = ''
      Config(
        prefix: ":t",
        language_delimiter: ">",
        max_entries: 3,
      )
    '';
    extraConfigFiles."nixos-options.ron".text = let
      #               ↓ home-manager refers to the nixos configuration as osConfig
      nixos-options = osConfig.system.build.manual.optionsJSON + "/share/doc/nixos/options.json";
      # merge your options
      options = builtins.toJSON {
        ":nix" = [nixos-options];
      };
    in ''
      Config(
        options:  ${options},
      )
    '';
  };
}
