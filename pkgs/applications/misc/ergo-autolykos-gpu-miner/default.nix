{ stdenv
, fetchFromGitHub
, curl
, cudatoolkit
}:
stdenv.mkDerivation rec {
  pname = "ergo-autolykos-gpu-miner-${version}";
  version = "unstable-2019-06-28";

  src = fetchFromGitHub {
    owner = "ergoplatform";
    repo = "Autolykos-GPU-miner";
    rev = "0a2e289aa12ad5b55f90735759721d35ec1812fc";
    sha256 = "1qm9phx97by1p83z8kd0paafpyb0gvsnbb0w3msm343p32f7mr7v";
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
