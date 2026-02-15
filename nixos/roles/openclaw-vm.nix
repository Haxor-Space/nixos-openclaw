{ pkgs, ... }:
{
  boot.loader.grub.device = "/dev/vda";

  networking.useDHCP = true;

  services.openssh.enable = true;
  services.qemuGuest.enable = true;

  time.timeZone = "UTC";

  users.users.captain = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAA...REPLACE_ME"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    git
    curl
    htop
  ];

  system.stateVersion = "24.11";
}
