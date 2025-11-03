#! /bin/sh

dir="$(readlink -f "$(dirname "$0")")"

nix-build -E "with import <nixpkgs> {}; callPackage $dir/all-stv-filtered.nix { stv-counts = callPackage $dir/all-stv.nix { ballotFile = $1; }; }"
