{ stdenv, fetchFromGitHub, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "ergo";
  version = "3.1.2";

  inherit jre;

  propagatedBuildInputs = [ jre ];

  builder = ./builder.sh;

  src = fetchurl {
    url = "https://github.com/ergoplatform/ergo/releases/download/v${version}/ergo-${version}.jar";
    sha256 = "19phr2rwpy8s28cva62h8wag274rl9qw4r273hf3v37has095ahs";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/ergoplatform/ergo;
    description = "Official Ergo full-node implementation";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ akamaus ];
  };
}
