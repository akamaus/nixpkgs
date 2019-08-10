{ stdenv
, fetchFromGitHub
, curl
, cudatoolkit
}:
stdenv.mkDerivation rec {
  pname = "ergo-autolykos-gpu-miner-${version}";
  version = "fork-2019-08-10";

  src = fetchFromGitHub {
    owner = "akamaus";
    repo = "Autolykos-GPU-miner";
    rev = "6db37fc9300deea5b4bc9661fde4cd6f56eb772d";
    sha256 = "143f8hj42gj1130f62flz6m7d8p6cxbdiw2d19g7r8449piajigj";
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
