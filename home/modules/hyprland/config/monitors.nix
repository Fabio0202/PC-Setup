{...}: {
  wayland.windowManager.hyprland.extraConfig = ''
        monitor=eDP-1,1920x1080@60.00Hz,0x0,1,vrr,0
        # monitor=desc:Chimei Innolux Corporation 0x14F2,preferred,auto,1.25,vrr,0
    # hier muss man noch eine Zeile erstellen um die Position einzustellen
  '';
}
