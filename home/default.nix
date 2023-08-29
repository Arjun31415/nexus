{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "prometheus";
  home.homeDirectory = "/home/prometheus";
  nixpkgs.config.allowUnfree = true;
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  imports = [
    ./audio
    ./gtk
    ./torrent
    ./shells
    ./dev
    ./waybar
    ./browsers
    ./communication
    ./hyprland
    ./notifications
  ];
  home.packages = with pkgs; [
    swww
    brightnessctl
    alejandra
    p7zip
    unzip
    starship
    mcfly
    pastebinit
    libreoffice-fresh
    (callPackage ./fastfetch {})
    inputs.anyrun.packages.${pkg.system}.anyrun-with-all-plugins
    inputs.hyprpaper.packages.${pkg.system}.hyprpaper
    inputs.hypr-contrib.packages.${pkg.system}.grimblast
    powertop
    cliphist
    stow
    kooha
    cpupower-gui
    wev
    ngrok
    imv
    hunspell
    hunspellDicts.en_US
    todoist-electron
    notion-app-enhanced
    font-awesome
    material-symbols
    siji
    font-manager
    inputs.ags.packages.${pkgs.system}.default
  ];
  fonts.fontconfig.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    extraConfig = {
      XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Screenshots";
    };
  };
  programs.btop.enable = true;

  programs.zathura.enable = true;
  services.dunst = {
    enable = true;
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
