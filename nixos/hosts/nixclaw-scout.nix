{
  imports = [
    ../roles/openclaw-vm.nix
    ../modules/secrets.nix
    ../workspaces/scout.nix
  ];

  networking.hostName = "nixclaw-scout";
}
