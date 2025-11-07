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
      julia
      qt5.qtwayland
      libsForQt5.qt5.qtwayland
      qt6.qtwayland
    ];
    shellHook = ''
      export LD_LIBRARY_PATH="${gfortran.cc.lib}/lib"
      export QT_PLUGIN_PATH="${pkgs.qt5.qtwayland}/${pkgs.qt5.qtbase.qtPluginPrefix}:${pkgs.qt6.qtwayland}/${pkgs.qt6.qtbase.qtPluginPrefix}"
          export QT_QPA_PLATFORM_PLUGIN_PATH="${pkgs.qt5.qtwayland}/${pkgs.qt5.qtbase.qtPluginPrefix}/platforms:${pkgs.qt6.qtwayland}/${pkgs.qt6.qtbase.qtPluginPrefix}/platforms"
    '';
  }
