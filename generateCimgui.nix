let
  pkgs = import <nixpkgs> {};
  # unstablepkgs = fetchTarball "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
  # unstable = import unstablepkgs { config = {}; overlays = []; };
  unstable = import <unstable> {};
in 
  pkgs.fastStdenv.mkDerivation {
    name = "Shell for zig";
    hardeningDisable = [ "all" ];
    nativeBuildInputs = with pkgs; [
      unstable.zig
      cmake
      llvm_17
      steam-run
      lua
      luajit
      gnumake
    ];

    LD_LIBRARY_PATH="/run/opengl-driver/lib:${pkgs.glfw}/lib";

    shellHook = ''
      cd cimgui/generator
      steam-run ./generator.sh
      cd ..
      make
      cd ..
      exit
    '';
  }
