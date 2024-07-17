# Mailcap settings.
{ config
, lib
, pkgs
, ...
}: {
  home.file.".mailcap".text =
    let
      # The location of the profile's bin.
      profileBin = "${config.home.profileDirectory}/bin";

      # The location of the default browser, if available.
      browser = config.home.sessionVariables.BROWSER or null;

      # The location of eog.
      eog = "${profileBin}/eog";

      # The location of evince.
      evince = "${profileBin}/evince";

      # The location of libreoffice.
      libreoffice = "${profileBin}/libreoffice";

      # The location of nohup.
      nohup = "${profileBin}/nohup";

      # The location of pdftotext.
      pdftotext = "${profileBin}/pdftotext";

      # The location of w3m.
      w3m = "${profileBin}/w3m";

      # The location of RunningX, a short program to check if running under X11.
      runningx = "${profileBin}/RunningX";

      # Disown the given command and send its file descriptors to /dev/null.
      # This is useful for starting a GUI command in the background.
      # We sleep as well to ensure that (neo)mutt actually waits a bit before
      # removing the temporary file it calls the command on, to give browsers
      # and the like a moment to open it before it's unlinked.
      disown = cmd:
        "${nohup} ${cmd} >/dev/null 2>&1 </dev/null & disown; sleep 5";

      # Generate the mailcap lines for libreoffice for a given MIME and its
      # extension.
      mkLibreofficeMailcap = mime: extension:
        ''
          ${mime}; ${disown "${libreoffice} %s"}; test=${runningx}; nametemplate=%s.${extension}
          ${mime}; ${libreoffice} --headless --cat %s; copiousoutput; nametemplate=%s.${extension}
        '';

      # The MIME/extension pairs for common document types libreoffice can
      # handle.
      libreofficeMimes = [
        # Microsoft Word formats.
        { mime = "application/msword"; ext = "doc"; }
        { mime = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"; ext = "docx"; }
        { mime = "application/vnd.ms-excel"; ext = "xls"; }
        { mime = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"; ext = "xlsx"; }
        { mime = "application/vnd.ms-powerpoint"; ext = "ppt"; }
        { mime = "application/vnd.openxmlformats-officedocument.presentationml.presentation"; ext = "pptx"; }

        # Opendocument formats.
        { mime = "application/vnd.oasis.opendocument.text"; ext = "odt"; }
        { mime = "application/vnd.oasis.opendocument.spreadsheet"; ext = "ods"; }
        { mime = "application/vnd.oasis.opendocument.presentation"; ext = "odp"; }
      ];

      # The mailcap entries for libreoffice.
      libreofficeMailcap =
        lib.concatMapStringsSep
          "\n"
          (x: mkLibreofficeMailcap x.mime x.ext)
          libreofficeMimes;

      # The mailcap entry for the browser, if available.
      browserMailcap =
        if browser == null then ""
        else "text/html; ${disown "${browser} %s"}; test=${runningx}; nametemplate=%s.html";
    in
    ''
      ${libreofficeMailcap}

      application/pdf; ${disown "${evince} %s"}; test=${runningx}; nametemplate=%s.pdf
      application/pdf; ${pdftotext} %s -; copiousoutput; nametemplate=%s.pdf

      ${browserMailcap}
      text/html; ${w3m} -I %{charset} -T text/html; copiousoutput; nametemplate=%s.html

      image/*; ${disown "${eog} %s"}
    '';

  home.packages = with pkgs; [
    # Ensure coreutils is available for nohup.
    coreutils

    # An image viewer.
    eog

    # A PDF (and other document types) viewer.
    evince

    # Libreoffice, for reading documents.
    # NOTE: This is still useful without a GUI, since it can view docx as text.
    libreoffice-fresh

    # This provides pdftotext, along with a couple other PDF utilities.
    poppler_utils

    # A utility to check if running in X11.
    runningx

    # A terminal browser.
    # This is used for turning HTML into formatted plaintext.
    w3m
  ];
}
