{pkgs}: let
  os =
    if pkgs.stdenv.isDarwin
    then "osx"
    else "linux";
  arch =
    {
      x86_64-linux = "x64";
      aarch64-linux = "arm64";
      x86_64-darwin = "x64";
      aarch64-darwin = "arm64";
    }
    ."${pkgs.stdenv.hostPlatform.system}"
    or (throw "Unsupported system: ${pkgs.stdenv.hostPlatform.system}");
  hash =
    {
      x64-linux_hash = "sha256-MkRKWMhH4x5Z9mURh8qpShaozHrBFOHHwTmFlU1wqS8=";
      arm64-linux_hash = "sha256-hYcah7DplzCP/2NOksy4EPk3ucjFJ5ld0U25+cSeYks=";
      x64-osx_hash = "sha256-uDQXfj4r56ewrhZdwOnF78L3M1o0jDLt/PZlfWxxV18=";
      arm64-osx_hash = "sha256-6WUeMIfF5juNHrLqep3mONqfcgxlBJOOJmHJkyHpZhU=";
    }
    ."${arch}-${os}_hash";
in
  pkgs.stdenv.mkDerivation rec {
    pname = "sonarr";
    version = "4.0.11.2680";
    src = pkgs.fetchurl {
      url = "https://github.com/Sonarr/Sonarr/releases/download/v${version}/Sonarr.main.${version}.${os}-${arch}.tar.gz";
      inherit hash;
    };
    nativeBuildInputs = [pkgs.makeWrapper];
    installPhase = ''

            runHook preInstall

            mkdir -p $out/{bin,share/${pname}-${version}}
            cp -r * $out/share/${pname}-${version}/.

            makeWrapper "${pkgs.dotnet-runtime}/bin/dotnet" $out/bin/sonarr \
            --add-flags "$out/share/${pname}-${version}/Sonarr.dll" \
            --prefix LD_LIBRARY_PATH : ${
        pkgs.lib.makeLibraryPath [
          pkgs.curl
          pkgs.sqlite
          pkgs.libmediainfo
          pkgs.mono
          pkgs.openssl
          pkgs.icu
          pkgs.zlib
        ]
      }

      runHook postInstall


    '';
  }
