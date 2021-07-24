# Setup for GEF, a GDB extension for reverse engineering.
{ gef
, pkgs
, ...
}:
pkgs.stdenv.mkDerivation {
  pname = "gef";
  version = gef.lastModifiedDate;
  src = gef;

  # Patch GEF to use the same Python as GDB invoked it with when writing
  # temporary scripts.
  patchPhase = ''
    sed -i \
      -e 's@pythonbin = which("python3\?")@pythonbin = sys.executable@g' \
      -e 's@PYTHONBIN = which("python3\?")@PYTHONBIN = sys.executable@g' \
      gef.py
  '';

  # Skip the build phase.
  buildPhase = ":";

  # Copy GEF to the install location.
  installPhase = ''
    cp -rv . $out
  '';
}
