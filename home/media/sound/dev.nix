# Configuration for making and editting music and sound files.
{ config
, inputs
, pkgs
, ...
}:
let
  # Given a plugin type, generate the path variable for where those kinds of
  # sound plugins should be found.
  mkPluginPath = pluginType: builtins.concatStringsSep ":" [
    # Plugins from the home directory.
    "${config.home.homeDirectory}/.${pluginType}"

    # Plugins from the current profile.
    "${config.home.profileDirectory}/lib/${pluginType}"
  ];
in
{
  home.packages = with pkgs; [
    # A multi-track recording/audio/MIDI software.
    ardour

    # A basic audio editor.
    audacity

    # A host for audio plugins.
    carla

    # A digital audio workstation.
    lmms

    # A tool to control a running JACK session and its connections.
    qjackctl

    # A set of tools for low-level editing of sound files.
    sox


    # A variety of audio plugins.
    adlplug
    aeolus
    AMB-plugins
    #ams-lv2
    artyFX
    bristol
    bshapr
    bslizr
    calf
    caps
    carla
    cmt
    csa
    distrho-ports
    drumgizmo
    drumkv1
    dssi
    eq10q
    fluidsynth
    #fmsynth
    fomp
    gxplugins-lv2
    helm
    infamousPlugins
    ingen
    ladspaPlugins
    linuxsampler
    mda_lv2
    metersLv2
    mod-distortion
    nova-filters
    rkrlv2
    qsynth
    setbfree
    sorcer
    speech-denoiser
    swh_lv2
    synthv1
    x42-avldrums
    xsynth_dssi
    yoshimi
    zam-plugins
    zynaddsubfx
  ];

  # The path for DSSI plugins.
  home.sessionVariables.DSSI_PATH = mkPluginPath "dssi";

  # The path for LADSPA plugins.
  home.sessionVariables.LADSPA_PATH = mkPluginPath "ladspa";

  # The path for LV2 plugins.
  home.sessionVariables.LV2_PATH = mkPluginPath "lv2";

  # The path for LXVST plugins.
  home.sessionVariables.LXVST_PATH = mkPluginPath "lxvst";

  # The path for VST plugins.
  home.sessionVariables.VST_PATH = mkPluginPath "vst";
}
