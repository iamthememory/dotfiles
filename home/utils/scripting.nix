# Various interpreters helpful for basic scripting in a terminal.
{ config
, pkgs
, ...
}: {
  home.packages = with pkgs;
    let
      python = python3.withPackages (p: with p; [
        matplotlib
        numpy
        pandas
        scipy
      ]);

      R = rWrapper.override {
        packages = [
        ];
      };
    in
    [
      # Bash, for scripting.
      bashInteractive

      # A rust REPL.
      evcxr

      # Octave, useful for math.
      octaveFull

      # Perl, useful for little inline snippets in terminal pipelines.
      perl

      # Python, which I sometimes use as an over-powered calculator.
      python

      # R, useful for statistics.
      R
    ];

  # When running python as a REPL, save its history here.
  home.sessionVariables.PYTHON_HISTORY =
    "${config.home.homeDirectory}/.python_history";
}
