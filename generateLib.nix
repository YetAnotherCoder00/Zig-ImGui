let
  pkgs = import <nixpkgs> {};
in 
  pkgs.clangStdenv.mkDerivation {
    name = "Shell for zig";
    hardeningDisable = [ "all" ];
    nativeBuildInputs = with pkgs; [
      glfw
      llvm_17
      libGL
      libGLU
    ];

    shellHook = ''
      zig build example_glfw_opengl3
      exit
    '';
  }
