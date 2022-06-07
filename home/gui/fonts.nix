# GUI font configuration.
{ pkgs
, ...
}: {
  # Discover all fonts installed in our profile.
  fonts.fontconfig.enable = true;

  # Packages to install.
  home.packages = with pkgs; [
    # The classic Microsoft fonts everyone uses.
    corefonts

    # The DejaVu fonts.
    dejavu_fonts

    # Various fontconfig utilities.
    fontconfig.bin

    # A font package for Japanese text.
    ipafont

    # A set of nice, open source fonts.
    league-of-moveable-type

    # A set of free fonts compatible with the classic Microsoft ones.
    liberation_ttf

    # A set of various monospaced fonts, patched with numerous extra unicode
    # glyphs for extra-shiny fonts in terminals, etc.
    nerdfonts

    # A set of nice fonts from Google.
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    noto-fonts-extra

    # A set of monospaced fonts patched with extra glyphs, although I believe
    # less extensive than nerdfonts.
    powerline-fonts
  ];
}
