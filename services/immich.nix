{ config, lib, pkgs, ... }:

{
  services.immich.enable = true;
  services.immich.port = 2283;
}