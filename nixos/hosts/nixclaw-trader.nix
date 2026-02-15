{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../roles/openclaw-vm.nix
    ../modules/secrets.nix
    ../workspaces/trader.nix
  ];

  networking.hostName = "nixclaw-trader";
}
