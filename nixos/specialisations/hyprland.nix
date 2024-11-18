{config, pkgs, inputs, ...} :
{
  programs.waybar = {
    enable = true;
  };
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # systemd.enable = true;
    # package = inputs.hyprland.packages."${unstablePkgs.stdenv.hostPlatform.system}".hyprland;
    # package = inputs.hyprland.packages.${unstablePkgs.stdenv.hostPlatform.system}.hyprland;
    # package = inputs.hyprland.packages.${unstablePkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =  inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}

