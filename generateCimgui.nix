let
  pkgs = import <nixpkgs> {};
  # unstablepkgs = fetchTarball "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
  # unstable = import unstablepkgs { config = {}; overlays = []; };
in 
  pkgs.fastStdenv.mkDerivation {
    name = "Shell for zig";
    hardeningDisable = [ "all" ];
    nativeBuildInputs = with pkgs; [
      zig
      cmake
      llvm_17
      steam-run
      lua
      luajit
      gnumake
    ];

    shellHook = ''
      cd cimgui/generator
      steam-run ./generator.sh
      cd ..
      make
      cd ..
      exit
    '';
  }
