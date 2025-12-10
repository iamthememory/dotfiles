# Firefox configuration.
{ inputs
, pkgs
, ...
}: {
  # Enable Firefox.
  programs.firefox.enable = true;

  # Use the binary to avoid having to do an expensive firefox build, since CUDA
  # support means we have to build onnxruntime.
  # Firefox builds (and especially the linking step) seem to take dozens of
  # gigabytes of memory.
  programs.firefox.package = pkgs.firefox-bin;

  # Extensions for Firefox.
  programs.firefox.profiles.default.extensions.packages =
    let
      # Extra Firefox addons.
      extraAddons =
        let
          pkgsWithXpiBuilder = pkgs // {
            inherit
              (inputs.nur.repos.rycee.firefox-addons) buildFirefoxXpiAddon;
          };
        in
        pkgs.lib.callPackageWith pkgsWithXpiBuilder ./firefox-addons.nix { };
    in
    with inputs.nur.repos.rycee.firefox-addons; with extraAddons; [
      # An ad blocker.
      adblock-plus

      # An extension that kills/unloads inactive tabs.
      auto-tab-discard

      # A tool that clears tracking data from URLs.
      clearurls

      # An extension that allows forcing dark styles on websites.
      darkreader

      # A downloads manager.
      downthemall

      # An extension to isolate shared cookies and info by tab type, e.g., work,
      # home, etc., for privacy.
      multi-account-containers

      # An extension to try to send do not track to servers, and to smartly
      # disable things that track anyway.
      privacy-badger

      # A tab manager.
      tab-session-manager

      # A tool for injecting javascript into pages.
      tampermonkey

      # An extension to provide Vi-like keybindings in Firefox.
      vimium

      # A pair of light/dark solarized themes.
      zen-fox
    ];

  # Settings for the default Firefox profile.
  programs.firefox.profiles.default.settings = {
    # Disable the warning on accessing about:config.
    "browser.aboutConfig.showWarning" = false;

    # Disable the on-disk cache.
    # This isn't as necessary with decent internet/memory, and with frequent
    # snapshots tends to balloon disk usage from all the churn.
    "browser.cache.disk.capacity" = 0;
    "browser.cache.disk.enable" = false;
    "browser.cache.disk.smart_size.enabled" = false;
    "browser.cache.disk_cache_ssl" = false;

    # Allow a larger memory cache than the default, which is a few dozen
    # megabytes.
    # Allow up to 512 MiB of RAM cache, caching things up to 12 MiB.
    "browser.cache.memory.capacity" = 512 * 1024;
    "browser.cache.memory.max_entry_size" = 12 * 1024;

    # Don't always open the download panel when downloading files.
    "browser.download.alwaysOpenPanel" = false;

    # Don't autohide the address bar and tab bar in fullscreen.
    "browser.fullscreen.autohide" = false;

    # Use dark mode in interfaces and websites.
    "browser.in-content.dark-mode" = true;

    # Remove the highlights from the new tab page.
    "browser.newtabpage.activity-stream.feeds.section.highlights" = false;

    # Remove the top stories from the new tab page.
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;

    # Remove the top sites from the new tab page.
    "browser.newtabpage.activity-stream.feeds.section.topsites" = false;

    # Don't warn if Firefox doesn't seem to be the default browser.
    "browser.shell.checkDefaultBrowser" = false;

    # Allow switching tabs by scrolling.
    "toolkit.tabbox.switchByScrolling" = true;

    # Don't show the menu when pressing ALT.
    "ui.key.menuAccessKeyFocuses" = false;

    # Set the system UI to dark themed.
    "ui.systemUsesDarkTheme" = 1;
  };
}
