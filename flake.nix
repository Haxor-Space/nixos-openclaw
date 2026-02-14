{
  description = "NixOS VM with OpenClaw game";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.openclaw-vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };

    # VM image for gnome-boxes
    packages.x86_64-linux.vm = self.nixosConfigurations.openclaw-vm.config.system.build.vm;
    
    # QCOW2 image for gnome-boxes
    packages.x86_64-linux.qcow = self.nixosConfigurations.openclaw-vm.config.system.build.qcow;
  };
}
