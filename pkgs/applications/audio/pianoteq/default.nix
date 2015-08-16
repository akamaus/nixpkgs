{  stdenv, requireFile, p7zip, libX11, alsaLib, freetype, libXext, libjack2,
   pianoteqSet ? {}
}:

let
  archDir =
    {
       "x86_64-linux" = "amd64";
    }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  pSet = { name = "pianoteq-v6.5.1-standard";
           src_name = "pianoteq_linux_trial_v651.7z";
           sha256 = "1sji8x42w7w0ailizmkc0njsy56jqk1vdkqjx03rw1fr5v1g5yas";
           executablePath = "Pianoteq 6/amd64/Pianoteq 6";
	   lv2Path = "Pianoteq 6/amd64/Pianoteq 6.lv2";
	 } // pianoteqSet;

in
stdenv.mkDerivation {
  inherit (pSet) name;

  buildInputs = [ p7zip ];

  src = requireFile rec {
    name = pSet.src_name;
    inherit (pSet) sha256;
    message = ''
       This nix expression requires that ${name} is
       already part of the store.
       Get the pianoteq 7z archive and and add it to the nix store with nix-store --add-fixed sha256 <FILE>.
    ''; };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  unpackPhase = "7z x $src";
  installPhase = ''
    mkdir -p $out/opt/Pianoteq
    mkdir $out/bin
    mkdir -p $out/lib/lv2/pianoteq.lv2
    cp "${pSet.executablePath}" $out/opt/Pianoteq/pianoteq
    cp -rv "${pSet.lv2Path}"/* $out/lib/lv2/pianoteq.lv2
    ln -s $out/opt/Pianoteq/pianoteq $out/bin/pianoteq
  '';

  libPath = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc
    libX11 alsaLib freetype libXext libjack2
  ];

  postFixup = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
    --set-rpath "$libPath" $out/bin/pianoteq

    patchelf --set-rpath "$libPath" "$out/lib/lv2/pianoteq.lv2"/*.so
  '';

  meta = {
    description = "Piano simulator";
    longDescription = ''
      Pianoteq is a famous piano simulator, which sounds very reality.
    '';
    homepage = "https://www.pianoteq.com/";
    license = stdenv.lib.licenses.unfree;
    platform = stdenv.lib.platforms.linux;
  };
}
