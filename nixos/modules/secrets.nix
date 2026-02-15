{ config, pkgs, sops-nix, ... }:
{
  imports = [
    sops-nix.nixosModules.sops
  ];

  assertions = [
    {
      assertion = builtins.pathExists ../../secrets/secrets.yaml;
      message = "Missing secrets/secrets.yaml. Create it with sops (see secrets/README.md).";
    }
  ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
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
}
