{ lib, runCommand, writeShellApplication, gnused, stv-counts }:

let
  normalizeResults = writeShellApplication {
    name = "normalize-results";
    runtimeInputs = [
      gnused
    ];

    text = ''
      inputDir="$1"
      outputDir="$2"
      file="$3"

      inputFilename="''${file#"$inputDir"}"
      outputFilename="$outputDir/$inputFilename"

      mkdir -p "$(dirname -- "$outputFilename")"
      sed -ne '/Count complete. The winning candidates are, in order of election:/,$ p' <"$file" >"$outputFilename"
    '';
  };
in
runCommand "stv-counts-filtered" {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "sha256-YMi4wXY1y63pZzAnk2NfZllCJrh0RbfiL7BmcPy2ltI=";
} ''
  stvCounts=${stv-counts}
  echo "*** Run this to try again:"
  echo "*** rm -f result"
  echo "*** nix-store --delete $stvCounts"
  echo "*** nix-store --delete $out"

  # Normalize all the results by searching for the winners.
  find $stvCounts -type f -name report.text \
    -exec ${lib.getExe normalizeResults} $stvCounts $out {} \;
''
