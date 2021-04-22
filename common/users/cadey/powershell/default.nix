{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.powershell ];
  home.file.".config/powershell/Microsoft.PowerShell_profile.ps1".source = ./profile.ps1;
}
