{ pkgs, stdenv }: 
with pkgs;
stdenv.mkDerivation {
  name = "no-ip";
  src = fetchurl {
    url = "http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz";
    sha256 = "14zmlv2a77dhpmr20pkv44k2wmxkf2zqixmf3ar5633ap7xbmfc2";
  };

  preInstall = ''
    makeFlagsArray+=(PREFIX="$out")
  '';

  patches = [ ./makefile.patch ];
}
