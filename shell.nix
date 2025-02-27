{pkgs ? import <nixpkgs> {}}:
with pkgs; let
  nixBin = writeShellScriptBin "nix" ''
    ${nixVersions.stable}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';
in
  mkShell {
    buildInputs = [git];
    shellHook = ''
      export FLAKE="$(pwd)"
      export PATH="$FLAKE/bin:${nixBin}/bin:$PATH"
    '';
  }
