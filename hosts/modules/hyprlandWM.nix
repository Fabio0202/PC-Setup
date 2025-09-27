{
  inputs,
  lib,
  pkgs,
  ...
}: {
  # Disable X11 completely
  services.xserver.enable = false;
  programs.xwayland.enable = true;

  # use latest hyprland from unstable
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  programs.hyprland.withUWSM = true; # Enable improved hyprland compatibility with uwsm

  # force wayland for electron apps
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_LAUNCH_FLAGS = "--enable-wayland-ime --wayland-text-input-version=3 --enable-features=WaylandLinuxDrmSyncobj";
  };

  services.gvfs.enable = true; # gnome virtual file system

  # Remove decorations for QT applications
  environment.sessionVariables = {
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  # Make GTK handle OpenURI; Hyprland handles screencast
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config = {
      common.default = ["hyprland" "gtk"];
      hyprland = {
        default = ["hyprland" "gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        "org.freedesktop.impl.portal.OpenURI" = ["gtk"];
        "org.freedesktop.impl.portal.Settings" = ["gtk"];
      };
    };
  };

  # Import the SDDM Wayland module
  imports = [./login.nix];
}
