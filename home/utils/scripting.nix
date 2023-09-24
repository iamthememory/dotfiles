# Various interpreters helpful for basic scripting in a terminal.
{ pkgs
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

      # Octave, useful for math.
      octaveFull

      # Perl, useful for little inline snippets in terminal pipelines.
      perl

      # Python, which I sometimes use as an over-powered calculator.
      python

      # R, useful for statistics.
      R
    ];

  # When running python as a REPL, save its history and use readline for
  # completion.
  home.sessionVariables.PYTHONSTARTUP =
    let
      pythonrc = pkgs.writeScript "pythonrc.py" ''
        # This file is sourced by interactive python sessions
        # Partially copied from <http://stackoverflow.com/questions/3613418/what-is-in-your-python-interactive-startup-script>

        from __future__ import division, print_function

        import atexit
        import os
        import readline
        import rlcompleter

        # Tab complete with readline
        readline.parse_and_bind("tab: complete")

        # History
        historyPath = os.path.expanduser("~/.history.py")

        def save_history(historyPath=historyPath):
            import readline
            readline.write_history_file(historyPath)

        if os.path.exists(historyPath):
            readline.read_history_file(historyPath)

        atexit.register(save_history)
        del os, atexit, readline, rlcompleter, save_history, historyPath

        # vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
      '';
    in
    "${pythonrc}";
}
