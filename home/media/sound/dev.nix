# Configuration for making and editting music and sound files.
{ config
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

    # A synthesizer.
    fluidsynth

    # A sampler.
    linuxsampler

    # A digital audio workstation.
    lmms

    # A tool to control a running JACK session and its connections.
    qjackctl

    # A synthesizer.
    qsynth

    # A set of tools for low-level editing of sound files.
    sox


    # A variety of audio plugins.
    # Search for more plugins:
    # nix-locate --minimal --at-root -t d -t s -r '/lib/(dssi|ladspa|lv2|lxvst|vst)' | sort | uniq | sed -e 's@\.out$@@' -e 's@^@    @'
    adlplug
    aeolus
    aether-lv2
    airwin2rack
    airwindows
    airwindows-lv2
    amb-plugins
    artyFX
    autotalent
    bankstown-lv2
    bchoppr
    bjumblr
    bolliedelayxt-lv2
    boops
    #bristol
    bs2b-lv2
    bschaffl
    bsequencer
    bshapr
    bslizr
    calf
    caps
    cardinal
    carla
    chow-centaur
    chow-kick
    chow-phaser
    chow-tape-model
    cmt
    csa
    ctagdrc
    deepfilternet
    delayarchitect
    dexed
    diopser
    distrho-ports
    dragonfly-reverb
    drumgizmo
    drumkv1
    dsp
    dssi
    ensemble-chorus
    eq10q
    faust-physicalmodeling
    fil-plugins
    filtr
    fire
    fluida-lv2
    fomp
    fverb
    gate12
    geonkick
    guitarix
    gxmatcheq-lv2
    gxplugins-lv2
    helm
    hybridreverb2
    infamousplugins
    ingen
    ir-lv2
    kapitonov-plugins-pack
    ladspaPlugins
    ladspa-sdk
    librearp-lv2
    librearp
    lsp-plugins
    lv2
    magnetophonDSP.CharacterCompressor
    magnetophonDSP.CompBus
    magnetophonDSP.ConstantDetuneChorus
    magnetophonDSP.faustCompressors
    magnetophonDSP.LazyLimiter
    magnetophonDSP.MBdistortion
    magnetophonDSP.pluginUtils
    magnetophonDSP.RhythmDelay
    magnetophonDSP.shelfMultiBand
    magnetophonDSP.VoiceOfFaust
    master_me
    mda_lv2
    melmatcheq-lv2
    #meters-lv2
    midi-trigger
    mod-arpeggiator-lv2
    mod-distortion
    molot-lite
    moospace
    neural-amp-modeler-lv2
    ninjas2
    noise-repellent
    nova-filters
    odin2
    openav-artyfx
    open-music-kontrollers.eteroj
    open-music-kontrollers.jit
    open-music-kontrollers.mephisto
    open-music-kontrollers.midi_matrix
    open-music-kontrollers.moony
    open-music-kontrollers.orbit
    open-music-kontrollers.router
    open-music-kontrollers.sherlock
    open-music-kontrollers.synthpod
    open-music-kontrollers.vm
    opnplug
    plugdata
    plujain-ramp
    proteus
    qdelay
    qmidiarp
    quadrafuzz
    reevr
    ripplerx
    rkrlv2
    rnnoise-plugin.ladspa
    rnnoise-plugin.lv2
    rnnoise-plugin.lxvst
    rnnoise-plugin
    rnnoise-plugin.vst3
    rubberband
    setbfree
    sfizz-ui
    sg-323
    show-midi
    socalabs-papu
    socalabs-rp2a03
    socalabs-sid
    socalabs-sn76489
    socalabs-voc
    sonobus
    sorcer
    spectmorph
    speech-denoiser
    stochas
    stone-phaser
    string-machine
    #surge
    surge-xt
    swh_lv2
    synthv1
    talentedhack
    tambura
    tamgamp-lv2
    tap-plugins
    time12
    tunefish
    uhhyou-plugins-juce
    uhhyou-plugins
    vaporizer2
    vocproc
    wolf-shaper
    x42-avldrums
    x42-gmsynth
    x42-plugins
    yoshimi
    ysfx
    zam-plugins
    zlcompressor
    zlequalizer
    zlsplitter
    #zynaddsubfx-fltk
    #zynaddsubfx-ntk
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
