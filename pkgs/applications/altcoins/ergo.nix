{ stdenv, fetchFromGitHub, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "ergo";
  version = "3.1.0";

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
    sha256 = "0v9qhx7gyihgj24y9g9238x32m9lccnivjd0lmjaqwvgagj67n3n";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/ergoplatform/ergo;
    description = "Official Ergo full-node implementation";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ akamaus ];
  };
}
