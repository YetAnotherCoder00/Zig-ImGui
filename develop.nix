let
  pkgs = import <nixpkgs> {};
  # unstablepkgs = fetchTarball "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
  # unstable = import unstablepkgs { config = {}; overlays = []; };
  unstable = import <unstable> {};
in 
  pkgs.stdenv.mkDerivation {
    name = "Shell for zig";
    nativeBuildInputs = with pkgs; [
      unstable.zig
      # cmake
      # llvm_17
    ];

    LD_LIBRARY_PATH="/run/opengl-driver/lib:${pkgs.glfw}/lib";

    shellHook = ''

    '';
  }
