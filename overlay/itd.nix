# Tweak itd to include graphics and its service file.
{ super
, ...
}: super.itd.overrideAttrs (oldAttrs: {
  # Include inputs needed for the GUI.
  buildInputs = with super; [
    libGL
    libx11
    libxcursor
    libxi
    libxinerama
    libxrandr
    libxxf86vm
  ];

  nativeBuildInputs = with super; oldAttrs.nativeBuildInputs ++ [
    pkg-config
  ];

  # Include itgui.
  subPackages = oldAttrs.subPackages ++ [ "cmd/itgui" ];
})
