{
  config,
  pkgs,
  ...
}: {
  users.users.simon = {
    isNormalUser = true;
    description = "simon";
    extraGroups = ["plugdev" "uinput" "networkmanager" "input" "wheel" "video" "audio" "podman"];
    shell = pkgs.zsh;
  };
}
