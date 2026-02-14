{ config, pkgs, ... }:

{
  # Import hardware configuration for VM
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot configuration for VM
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  # Hostname
  networking.hostName = "openclaw-vm";

  # Enable NetworkManager for easy network configuration
  networking.networkmanager.enable = true;

  # Set time zone
  time.timeZone = "UTC";

  # Enable X11 and GNOME desktop
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable OpenGL for gaming
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Define a user account
  users.users.openclaw = {
    isNormalUser = true;
    description = "OpenClaw User";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    password = "openclaw"; # Default password - should be changed
  };

  # Enable automatic login for convenience in VM
  services.displayManager.autoLogin = {
    enable = true;
    user = "openclaw";
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # OpenClaw game
    openclaw
    
    # Web browser
    chromium
    
    # Basic utilities
    vim
    wget
    curl
    git
    htop
    
    # File manager (if not included in GNOME)
    gnome.nautilus
    
    # Terminal
    gnome.gnome-terminal
  ];

  # Enable guest additions for better VM integration
  virtualisation.vmVariant = {
    virtualisation.memorySize = 4096;
    virtualisation.cores = 2;
    virtualisation.qemu.options = [
      "-vga virtio"
      "-display gtk,gl=on"
    ];
  };

  # Firewall configuration
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];

  # Enable SSH for remote access (optional)
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = true;
  };

  # System state version
  system.stateVersion = "24.05";
}
