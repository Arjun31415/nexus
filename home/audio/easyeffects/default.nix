{pkgs, ...}: {
  # services.easyeffects.enable = false;

  home.packages = with pkgs; [easyeffects];
}
