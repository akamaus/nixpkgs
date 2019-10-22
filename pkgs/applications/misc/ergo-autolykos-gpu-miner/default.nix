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
    rev = "e010eb047f1d0bbfd76975310df1fda3821a0596";
    sha256 = "1x5mz0ncggp60276rwc6n6i3r57ydfsxaqw0m2bb9v9rn5wdbaic";
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
