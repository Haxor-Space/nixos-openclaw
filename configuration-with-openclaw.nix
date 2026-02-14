{ config, pkgs, lib, ... }:

let
  # Uncomment this to use custom openclaw package
  # customOpenClaw = pkgs.callPackage ./openclaw.nix {};
  
  # Helper function to safely include openclaw if it exists
  tryOpenClaw = builtins.tryEval (pkgs.openclaw or null);
  hasOpenClaw = tryOpenClaw.success && tryOpenClaw.value != null;
  
in {
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
    # Note: Using initialPassword instead of password for better security
    initialPassword = "openclaw";
  };

  # Enable automatic login for convenience in VM
  services.displayManager.autoLogin = {
    enable = true;
    user = "openclaw";
  };

  # Workaround for GNOME autologin issue
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # System packages
  environment.systemPackages = with pkgs; [
    # Web browsers
    chromium
    firefox
    
    # Basic utilities
    vim
    wget
    curl
    git
    htop
    tree
    file
    unzip
    
    # Development tools (optional)
    gcc
    gnumake
    
    # File manager (if not included in GNOME)
    gnome.nautilus
    
    # Terminal
    gnome.gnome-terminal
    
    # Text editor
    gnome.gedit
    
    # Alternative games for testing
    supertux
    
  ] ++ lib.optional hasOpenClaw pkgs.openclaw
    # Uncomment below to use custom openclaw package instead
    # ++ [ customOpenClaw ]
  ;

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
