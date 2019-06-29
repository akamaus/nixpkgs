{ stdenv, fetchFromGitHub, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "ergo";
  version = "3.0.0";

  inherit jre;

  propagatedBuildInputs = [ jre ];

  builder = ./builder.sh;

  # src = fetchFromGitHub {
  #   owner = "ergoplatform";
  #   repo = pname;
  #   rev = "v${version}";
  #   sha256 = "087jk0gh13y5cdn11w274ig1qrb8r9gncvfkhc04hv4n03b4504i";
  # };

  src = fetchurl {
    url = "https://github.com/ergoplatform/ergo/releases/download/v${version}/ergo-${version}.jar";
    sha256 = "1q1d5kx4adzba5d407wrq587vz0344lzgxvmj9p8xh8vdb407s4v";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/ergoplatform/ergo;
    description = "Official Ergo full-node implementation";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ akamaus ];
  };
}
