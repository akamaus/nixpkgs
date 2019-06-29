{ stdenv
, fetchFromGitHub
, curl
, cudatoolkit
}:
stdenv.mkDerivation rec {
  pname = "ergo-autolykos-gpu-miner-${version}";
  version = "unstable-2019-06-21";

  src = fetchFromGitHub {
    owner = "ergoplatform";
    repo = "Autolykos-GPU-miner";
    rev = "f64a2f5138492d4c5bb83a8adbda9b913f66ec14";
    sha256 = "053lkdbiz1xha81skrij4lr49lqgmw0wgl9v4cy2h73f3qq0mapw";
  };

  buildPhase = ''
    cd secp256k1/
    sed -i s:/bin/bash:bash: Makefile
    make all
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp auto.out $out/bin/ergo-autolykos-gpu-miner
  '';

  propagatedBuildInputs = [
    cudatoolkit
    curl
  ];

  meta = with stdenv.lib; {
    description = "Ergo GPU(CUDA) Miner";
    homepage = https://github.com/ergoplatform/Autolykos-GPU-miner;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ akamaus ];
  };
}
