# Shared desktop config (Sway + Wayland stack)
{ config, lib, pkgs, ... }:
{
  programs.sway.enable = true;

  services.displayManager.ly.enable = true;

  environment.systemPackages = with pkgs; [
    waybar
    fastfetch
    git
    arrpc
    lf
    bemenu
    j4-dmenu-desktop
    swayidle
    waylock
    xdg-desktop-portal-termfilechooser
    chafa
    file
    portablemc
    waybar
    fastfetch
    btop
    ncdu
    tailscale
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-termfilechooser
    ];
    config.sway = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
    };
    config.common = {
      "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
    };
  };

  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.pam.services.waylock = {};

  hardware.enableRedistributableFirmware = true;
}
