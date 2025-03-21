{ stdenv
, fetchurl
, pkgs
, lib
,
...
}:

stdenv.mkDerivation rec {
  name = "cpolar";
  version = "3.3.12";
  src = fetchurl {
    url = "https://www.cpolar.com/static/downloads/releases/${version}/cpolar-stable-linux-amd64.zip";
    sha256 = "sha256-89Z28kjg7EYyjeFKKu9EJlsLF5gvn8vwmI4v/DfHikU=";
  };
  nativeBuildInputs = with pkgs; [ unzip ];
  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp cpolar $out/bin
  '';
}


