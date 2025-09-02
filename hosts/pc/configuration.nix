# configuration.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../modules/hardware.nix
    # Importiere das xserver-gnome Modul
    # ../modules/gnome.nix
    ../modules/hyprlandWM.nix
    ../modules/user.nix
    ../modules/locale.nix
    ../modules/audio.nix
    ../modules/user.nix
    ../modules/bluetooth.nix
    ../modules/energy-management.nix
    ../modules/environment-variables.nix
    ../modules/fonts.nix
    ../modules/gaming.nix
    ../modules/gc.nix
    ../modules/light.nix
    ../modules/networking.nix
    # ../modules/stylix.nix
    ../modules/swap.nix
    ../modules/system.nix
  ];

  # Bootloader und Kernel-Konfigurationen bleiben unverändert
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Installiere Firefox
  programs.firefox.enable = true;

  # Zsh konfigurieren
  programs.zsh.enable = true;

  # Weitere Dienste wie CUPS und Pipewire
  services.printing.enable = true;

  # Systemversion
  system.stateVersion = "25.11";
}
