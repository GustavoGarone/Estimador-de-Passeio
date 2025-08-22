with import <nixpkgs> {};
  stdenv.mkDerivation {
    name = "Julia build";
    buildInputs = [
      binutils
      blas
      gcc
      gfortran
      gfortran.cc.lib
      gnum4
      lapack
      libgccjit
      openblas
      perl
      zlib
      poppler-utils
    ];
    shellHook = ''
      export LD_LIBRARY_PATH="${gfortran.cc.lib}/lib"
    '';
  }
