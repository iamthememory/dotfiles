# Configure bat, a cat clone with syntax highlighting and git support.
{ ...
}: {
  # Enable bat.
  programs.bat.enable = true;

  # Configure bat.
  programs.bat.config = {
    # Use the solarized-dark theme.
    theme = "Solarized (dark)";
  };
}
