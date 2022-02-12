{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  shellHook = "bash bootstrap.sh";
}
