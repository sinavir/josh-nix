{ lib
, rustPlatform
, breakpointHook
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
, nodejs
, npmHooks
, fetchNpmDeps
, python3
, curl
, gitMinimal
}:
let package = rustPlatform.buildRustPackage (rec {
  pname = "josh";
  version = "23.02.14";

  src = fetchFromGitHub {
    owner = "josh-project";
    repo = "josh";
    rev = "4b40183c3f7d17d4d8d13279d874f69c902dfc7e"; #"r${finalAttrs.version}";
    hash = "sha256-a1f0kZjseRoc75t1oC+RmMDp5AoCzkp7pzb1injiAGw=";
  };

  JOSH_VERSION = version;

  outputs = [ "out" "web" ];

  cargoHash = "sha256-wCETfTfKs7q6ltuykanUhKlZRU//W515+2ANqhAz5X8=";

  npmDeps = fetchNpmDeps {
    name = "${pname}-npm-deps";
    inherit src;
    sourceRoot = "source/josh-ui";
    hash = "sha256-AN4GfcPD2XwgYa/CnY/28DbPSKoCyBub4wH6/lrljmo=";
  };
  
  npmRoot="josh-ui";

  nativeBuildInputs = [
    pkg-config
    nodejs
    npmHooks.npmConfigHook
    breakpointHook
  ];

  buildInputs = [
    libgit2
    python3
    openssl
    zlib
  ];

  PUBLIC_URL = "/josh-ui/";
  
  postInstall = ''
    mkdir -p $web
    mkdir -p $out/bin
    mv scripts/git-sync $out/bin
    mv static/* $web
    '';
  checkFetures = [ "test-server" ];
  nativeCheckInputs = [ python3.pkgs.cram curl gitMinimal ];
  postCheck = ''
    ls -lahR
    '';

  passthru = {
    shellPath = "/bin/josh-ssh-shell";
  };

  meta = with lib; {
    description = "Just One Single History";
    homepage = "https://github.com/josh-project/josh";
    platforms = [ "x86_64-linux" ];
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
});
in package
