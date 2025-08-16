let
  config = {
    allowUnfree = true;
  };
  pkgs = import <nixpkgs> {inherit config;};
in
  (pkgs.buildFHSEnv {
    name = "pybetinha";
    targetPkgs = pkgs: (with pkgs; [
      (python3.withPackages (python-pkgs: [
        python-pkgs.virtualenv
        python-pkgs.pip
        python-pkgs.sympy
        python-pkgs.matplotlib
        python-pkgs.numpy
        python-pkgs.ipython
        python-pkgs.scipy
      ]))
    ]);
    runScript = "fish";
  }).env
