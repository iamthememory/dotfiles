# Configuration for nixpkgs.
{
  # Allow unfree packages to be built and installed.
  allowUnfree = true;

  # Allow installing packages even if the system is unsupported and may not
  # work properly.
  #allowUnsupportedSystem = true;

  # Accept the Android SDK license.
  android_sdk.accept_license = true;

  # Enable widevine for DRMed content in Chromium.
  chromium.enableWideVine = true;

  # Enable proprietary codecs in Chromium.
  chromium.proprietaryCodecs = true;

  # Enable pulseaudio support in Chromium.
  chromium.pulseSupport = true;

  # Enable CUDA support.
  cudaSupport = true;

  # Allow dotnet 7 for now since vintagestory needs it.
  # FIXME: If vintagestory switches to a more up to date dotnet version, remove
  # this.
  permittedInsecurePackages = [
    "dotnet-runtime-7.0.20"
    "dotnet-runtime-wrapped-7.0.20"
    "dotnet-wrapped-7.0.20"
  ];
}
