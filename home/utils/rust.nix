# General rust configuration.
{ config
, inputs
, pkgs
, ...
}: {
  home.packages = with pkgs;
    let
      rustToolchain = inputs.rust-bin.selectLatestNightlyWith (toolchain:
        toolchain.default.override {
          extensions = [
            "cargo"
            "clippy"
            "llvm-bitcode-linker"
            "llvm-tools"
            "miri"
            "reproducible-artifacts"
            "rust"
            "rust-analysis"
            "rust-analyzer"
            "rust-docs"
            "rust-docs-json"
            "rust-std"
            "rust-src"
            "rustc"
            "rustc-codegen-cranelift"
            "rustc-dev"
            "rustc-docs"
            "rustfmt"
          ];
        });

      rustPlatform = pkgs.makeRustPlatform {
        cargo = rustToolchain;
        rustc = rustToolchain;
      };
    in
    [
      gcc
      rustToolchain
      valgrind

      # Cargo plugins.
      cargo-about
      cargo-audit
      cargo-auditable
      cargo-bloat
      cargo-cache
      cargo-crev
      cargo-criterion
      cargo-cross
      cargo-deny
      cargo-edit
      cargo-expand
      cargo-feature
      cargo-features-manager
      cargo-flamegraph
      cargo-geiger
      cargo-info
      cargo-make
      cargo-msrv
      cargo-outdated
      cargo-readme
      cargo-semver-checks
      cargo-supply-chain
      cargo-udeps
      cargo-valgrind
    ];

  # Rustfmt settings.
  xdg.configFile."rustfmt/rustfmt.toml".source =
    let
      toTOML = (pkgs.formats.toml { }).generate;
    in
    toTOML "rustfmt.toml" {
      # Use the 2021 edition of Rust by default.
      edition = "2021";

      # When splitting imports like `use foo::{x, y, z}`, across multiple lines,
      # enforce one thing per line.
      # E.g., format to
      #   use foo:{
      #     long_identifier,
      #     another_identifier,
      #     yet_another,
      #   }
      # rather than
      #   use foo:{
      #     long_identifier, another_identifier,
      #     yet_another,
      #   }
      imports_layout = "HorizontalVertical";

      # Wrap lines at 80 characters.
      max_width = 80;
    };
}
