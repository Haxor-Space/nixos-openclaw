{ config, pkgs, nix-openclaw, ... }:

{
  # Import hardware configuration for VM
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.overlays = [
    nix-openclaw.overlays.default
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
    driSupport32Bit = true;
  };

  # Define a user account
  users.users.openclaw = {
    isNormalUser = true;
    description = "OpenClaw User";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    # Note: Using initialPassword for first boot (can be changed by user)
    initialPassword = "openclaw";
  };

  # Keep the OpenClaw user service running without an active login session
  # Enable linger for openclaw user to keep services running
  systemd.tmpfiles.rules = [
    "f /var/lib/systemd/linger/openclaw 0644 root root - -"
  ];

  home-manager.users.openclaw = { pkgs, ... }: {
    imports = [
      (nix-openclaw.homeManagerModules.openclaw or nix-openclaw.homeManagerModules.default)
    ];
    programs.home-manager.enable = true;
    home.homeDirectory = "/home/openclaw";
    home.stateVersion = "24.05";

    programs.openclaw = {
      enable = true;
      documents = ./openclaw-documents;

      # Replace the token before using the chatbot.
      config = {
        gateway = {
          mode = "local";
          auth = {
            token = "CHANGE_ME";
          };
        };
      };

      instances.default = {
        enable = true;
        package = pkgs.openclaw;
        stateDir = "/home/openclaw/.openclaw";
        workspaceDir = "/home/openclaw/.openclaw/workspace";
        plugins = [ ];
      };
    };
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
    # OpenClaw AI chatbot (from nix-openclaw)
    openclaw
    
    # Web browser
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
    
    # File manager (if not included in GNOME)
    gnome.nautilus
    
    # Terminal
    gnome.gnome-terminal
    
    # Optional games for testing the VM
    # supertux
    # supertuxkart
    # 0ad
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
