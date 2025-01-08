# General rust configuration.
{ config
, inputs
, pkgs
, ...
}: {
  home.packages =
    let
      rustToolchain = inputs.rust-bin.selectLatestNightlyWith (toolchain:
        toolchain.default.override {
          extensions = [
            "cargo"
            "clippy"
            "llvm-bitcode-linker"
            "llvm-tools"
            "miri"
            "rls"
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
      pkgs.gcc
      rustToolchain
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
