# OpenClaw Package Notes

## OpenClaw Availability

OpenClaw may or may not be available in nixpkgs depending on the channel version. If the package is not found during build, you have several options:

### Option 1: Use a Custom Derivation

Create a `openclaw.nix` file in this directory with a custom package definition:

```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "openclaw";
  version = "1.0";
  
  src = pkgs.fetchFromGitHub {
    owner = "OpenClaw";
    repo = "OpenClaw";
    rev = "v1.0";  # Update with actual version
    sha256 = "...";  # Update with actual hash
  };
  
  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
  ];
  
  buildInputs = with pkgs; [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    libpng
    zlib
    tinyxml-2
  ];
  
  meta = with pkgs.lib; {
    description = "Open-source implementation of Claw";
    homepage = "https://github.com/OpenClaw/OpenClaw";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
```

Then import it in `configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  (callPackage ./openclaw.nix {})
  # ... rest of packages
];
```

### Option 2: Remove OpenClaw from Configuration

If you just want to test the VM setup without OpenClaw initially, comment out the openclaw line in `configuration.nix`:

```nix
environment.systemPackages = with pkgs; [
  # openclaw  # Comment this out if package not available
  chromium
  # ... rest
];
```

### Option 3: Search Nixpkgs

Search for available game packages:
```bash
nix search nixpkgs openclaw
nix search nixpkgs claw
nix search nixpkgs games
```

## Game Assets

Even if OpenClaw builds successfully, you may need the original game assets (graphics, sounds, levels) to run it. These are typically not included in the package due to copyright and must be obtained separately from owning the original game.

Check the OpenClaw documentation for:
- Where to place game assets
- Which files are required
- Supported game versions
