# Host-specific config for bulbasaur-nix (Desktop)
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bulbasaur-nix";

  programs.steam.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # DRM Log noise in Ly
  boot.consoleLogLevel =3;
  # AMD GPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
