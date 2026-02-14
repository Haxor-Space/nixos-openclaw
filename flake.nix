{
  description = "NixOS VM with OpenClaw AI chatbot";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-openclaw.url = "github:openclaw/nix-openclaw/main";
  };

  outputs = { self, nixpkgs, home-manager, nix-openclaw }: {
    nixosConfigurations.openclaw-vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit nix-openclaw;
      };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit nix-openclaw;
          };
        }
      ];
    };

    # VM image for gnome-boxes
    packages.x86_64-linux.vm = self.nixosConfigurations.openclaw-vm.config.system.build.vm;
    
    # QCOW2 image for gnome-boxes
    packages.x86_64-linux.qcow = self.nixosConfigurations.openclaw-vm.config.system.build.qcow;
  };
}
