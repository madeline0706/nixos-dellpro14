# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  programs.sway.enable = true;
  services.displayManager.ly.enable = true;
  environment.systemPackages = with pkgs; [
    waybar
    git
    fastfetch
  ];


  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "arcanine-nix";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Los_Angeles";

  # User
  users.users.madeline = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  system.stateVersion = "26.05";

}

