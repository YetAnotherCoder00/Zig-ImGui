let
  pkgs = import <nixpkgs> {};
  # unstablepkgs = fetchTarball "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
  # unstable = import unstablepkgs { config = {}; overlays = []; };
  unstable = import <unstable> {};
in 
  pkgs.clangStdenv.mkDerivation {
    name = "Shell for zig";
    hardeningDisable = [ "all" ];
    nativeBuildInputs = with pkgs; [
      unstable.zig
      glfw
      llvm_17
      libGL
      libGLU
      # pkg-config
      # libglvnd
    ];

    # buildInputs = with pkgs; [
    #   mesa
    #   freeglut
    # ];

    # LD_LIBRARY_PATH="/run/opengl-driver/lib:/run/opengl-driver-32/lib";

    shellHook = ''
      clear
      ls ${pkgs.libGL}/lib
      zig build example_glfw_opengl3
      exit
    '';
  }
