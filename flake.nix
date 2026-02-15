{
  description = "NixClaw reproducible NixOS system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, sops-nix }:
    let
      system = "x86_64-linux";
      mkHost = hostModule: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          hostModule
        ];
        specialArgs = {
          inherit sops-nix;
        };
      };
    in
    {
      nixosConfigurations = {
        nixclaw-scout = mkHost ./nixos/hosts/nixclaw-scout.nix;
        nixclaw-cron = mkHost ./nixos/hosts/nixclaw-cron.nix;
        nixclaw-trader = mkHost ./nixos/hosts/nixclaw-trader.nix;
      };
    };
}
