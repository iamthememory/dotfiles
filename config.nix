# Configuration for nixpkgs.
{
  # Allow unfree packages to be built and installed.
  allowUnfree = true;

  # Allow installing packages even if the system is unsupported and may not
  # work properly.
  allowUnsupportedSystem = true;

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
}
