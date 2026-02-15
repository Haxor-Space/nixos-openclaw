{ config, lib, pkgs, sops-nix, ... }:
let
  secretsPresent = builtins.pathExists config.nixclaw.secretsFile;
in
{
  imports = [
    sops-nix.nixosModules.sops
  ];

  options.nixclaw.secretsFile = lib.mkOption {
    type = lib.types.path;
    default = ../../secrets/secrets.yaml;
    description = "Path to the encrypted sops secrets file (can point to a private repo checkout).";
  };

  config = lib.mkIf secretsPresent {
    sops.defaultSopsFile = config.nixclaw.secretsFile;
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";

    sops.secrets.openclaw_api_key = { };
    sops.secrets.github_token = { };

    systemd.services.openclaw-secret-demo = {
      description = "Example service with secret file path";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        Environment = "OPENCLAW_API_KEY_FILE=${config.sops.secrets.openclaw_api_key.path}";
        ExecStart = "${pkgs.coreutils}/bin/true";
      };
    };
  };
}
