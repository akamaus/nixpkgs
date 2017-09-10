{ stdenv
, fetchgit
, cmake
, jsoncpp
, libjson_rpc_cpp
, curl
, boost
, leveldb
, cryptopp
, libcpuid
, ocl-icd
, miniupnpc
, libmicrohttpd
, gmp
, mesa
, cudatoolkit
, extraCmakeFlags ? []
}:
stdenv.mkDerivation rec {
  name = "cpp-ethereum-${version}";
  version = "1.3.1-akamaus";

  src = fetchgit {
    url = "https://github.com/akamaus/cpp-ethereum";
    rev = "c3d8c78a97b6cc362ad993b714426170fa70de78";
  };
  
  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" extraCmakeFlags ];

  configurePhase = ''
    export BOOST_INCLUDEDIR=${boost.dev}/include
    export BOOST_LIBRARYDIR=${boost.out}/lib

    mkdir -p Build/Install
    pushd Build

    cmake .. -DETHASHCUDA=1 -DETHASHCL=0 -DETHSTRATUM=1 -DGUI=0 -DCMAKE_INSTALL_PREFIX=$(pwd)/Install $cmakeFlags
  '';

  enableParallelBuilding = true;

  runPath = with stdenv.lib; makeLibraryPath ([ stdenv.cc.cc ] ++ buildInputs);

  installPhase = ''
    make install

    mkdir -p $out

    for f in Install/lib/*.so* $(find Install/bin -executable -type f); do
      patchelf --set-rpath $runPath:$out/lib $f
    done

    cp -r Install/* $out
  '';

  buildInputs = [
    cmake
    jsoncpp
    libjson_rpc_cpp
    curl
    boost
    leveldb
    cryptopp
    libcpuid
    ocl-icd
    miniupnpc
    libmicrohttpd
    gmp
    mesa
    cudatoolkit
  ];

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Ethereum C++ client";
    homepage = https://github.com/ethereum/cpp-ethereum;
    license = licenses.gpl3;
    maintainers = with maintainers; [ artuuge ];
    platforms = platforms.linux;
  };
}
