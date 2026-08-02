{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gtk4,
  gtk4-layer-shell,
  networkmanager,
  bluez,
}:

rustPlatform.buildRustPackage rec {
  pname = "orbit";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "LifeOfATitan";
    repo = "orbit";
    rev = "main";
    sha256 = "18xO4DcU9u3FFem19muJ0R8K7V/mzOp68EE5ASQ3swg=";
  };

  cargoLock.lockFile = "${src}/Cargo.lock";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk4
    gtk4-layer-shell
    networkmanager
    bluez
  ];

  meta = with lib; {
    description = "Wifi + Bluetooth module for Wayland compositors";
    homepage = "https://github.com/LifeOfATitan/orbit";
    license = licenses.mit;
  };
}
