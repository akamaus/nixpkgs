{ cmake, fetchgit, luajit, stdenv }:

stdenv.mkDerivation {
      name = "torch-7";
      src = fetchgit {
        url = "https://github.com/torch/torch7.git";
        rev = "14ef272fff8206546a948b7161fc143115564994";
        sha256="0d4wyyy7sz1zmlzvhls9lyn5h8qfpxann2v2fhw44lp0b0fwqws3";
      };

      buildInputs = [ cmake luajit ];
}
