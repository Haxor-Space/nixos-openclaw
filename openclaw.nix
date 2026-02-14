{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, SDL2
, SDL2_image
, SDL2_mixer
, SDL2_ttf
, libpng
, zlib
, tinyxml-2
, pcre
, libvorbis
, libogg
}:

stdenv.mkDerivation rec {
  pname = "openclaw";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "OpenClaw";
    repo = "OpenClaw";
    # Use the latest stable tag or commit
    # You may need to update this to the actual latest version
    rev = "1.0";  # Update this with actual tag/commit
    sha256 = lib.fakeHash;  # Replace with actual hash after first build
    # To get the hash:
    # 1. Run the build once - it will fail
    # 2. Copy the hash from the error message
    # 3. Replace lib.fakeHash with the actual hash string
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    libpng
    zlib
    tinyxml-2
    pcre
    libvorbis
    libogg
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  # OpenClaw requires game assets to run
  # These are not included and must be obtained separately
  postInstall = ''
    mkdir -p $out/share/openclaw
    echo "Game assets are required to run OpenClaw." > $out/share/openclaw/README.txt
    echo "Please copy the assets from the original Claw game." >> $out/share/openclaw/README.txt
  '';

  meta = with lib; {
    description = "Open-source reimplementation of Captain Claw (1997)";
    longDescription = ''
      OpenClaw is an open-source reimplementation of the classic 1997 platformer
      Captain Claw. This package provides the game engine, but you must provide
      the original game assets separately.
    '';
    homepage = "https://github.com/OpenClaw/OpenClaw";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
