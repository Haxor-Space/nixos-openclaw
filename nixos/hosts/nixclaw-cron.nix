{
  imports = [
    ./hardware-configuration.nix
    ../roles/openclaw-vm.nix
    ../modules/secrets.nix
    ../workspaces/cron.nix
  ];

  networking.hostName = "nixclaw-cron";
}
