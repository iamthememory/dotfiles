# Solarized colors.
rec {
  # The colors, as named on https://github.com/altercation/solarized.
  colorNames = {
    # The accent colors.
    yellow = "#b58900";
    orange = "#cb4b16";
    red = "#dc322f";
    magenta = "#d33682";
    violet = "#6c71c4";
    blue = "#268bd2";
    cyan = "#2aa198";
    green = "#859900";

    # The base colors, from dark to light.
    base03 = "#002b36";
    base02 = "#073642";
    base01 = "#586e75";
    base00 = "#657b83";
    base0 = "#839496";
    base1 = "#93a1a1";
    base2 = "#eee8d5";
    base3 = "#fdf6e3";
  };

  # The basic 16 colors, for solarized dark.
  darkColors = with colorNames; {
    # Black.
    color0 = base02;

    # Red.
    color1 = red;

    # Green.
    color2 = green;

    # Yellow.
    color3 = yellow;

    # Blue.
    color4 = blue;

    # Magenta.
    color5 = magenta;

    # Cyan.
    color6 = cyan;

    # White.
    color7 = base2;

    # Bright black (gray).
    color8 = base03;

    # Bright red.
    color9 = orange;

    # Bright green.
    color10 = base01;

    # Bright yellow.
    color11 = base00;

    # Bright blue.
    color12 = base0;

    # Bright magenta.
    color13 = violet;

    # Bright cyan.
    color14 = base1;

    # Bright white.
    color15 = base3;
  };

  # The basic 16 colors, for solarized light.
  lightColors = with colorNames; {
    # Black.
    color0 = base2;

    # Red.
    color1 = red;

    # Green.
    color2 = green;

    # Yellow.
    color3 = yellow;

    # Blue.
    color4 = blue;

    # Magenta.
    color5 = magenta;

    # Cyan.
    color6 = cyan;

    # White.
    color7 = base02;

    # Bright black (gray).
    color8 = base3;

    # Bright red.
    color9 = orange;

    # Bright green.
    color10 = base1;

    # Bright yellow.
    color11 = base0;

    # Bright blue.
    color12 = base00;

    # Bright magenta.
    color13 = violet;

    # Bright cyan.
    color14 = base01;

    # Bright white.
    color15 = base03;
  };
}
