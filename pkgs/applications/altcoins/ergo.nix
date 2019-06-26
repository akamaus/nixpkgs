{ stdenv, fetchFromGitHub, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "ergo";
  version = "2.1.2";

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
    url = "https://github.com/ergoplatform/ergo/releases/download/v${version}/ergo-testnet-${version}.jar";
    sha256 = "0l15nxiamznf71bsxq6z345cy3lqh44k3jwwjlcnan211miqr2vb";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/ergoplatform/ergo;
    description = "Official Ergo full-node implementation";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ akamaus ];
  };
}
