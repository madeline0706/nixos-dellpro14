{ config, pkgs, ... }:
{
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    terminus_font
  ];
  imports = [
    ./sway.nix
    ./waybar.nix
    ./foot.nix
  ];
}
