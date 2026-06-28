{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  home-manager.users.madeline.imports = [ ./displays.nix ];
  # Stuff for my Pi 5
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ]; #to build pi 5 image
  nix.settings.trusted-users = [ "madeline" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bulbasaur-nix";

  programs.steam.enable = true;

  # DRM Log noise in Ly
  boot.consoleLogLevel = 3;
  # AMD GPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
