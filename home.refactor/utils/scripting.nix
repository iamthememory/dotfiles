# Various interpreters helpful for basic scripting in a terminal.
{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Perl, useful for little inline snippets in terminal pipelines.
    perl

    # Python, which I sometimes use as an over-powered calculator for reasons.
    python3
  ];
}
