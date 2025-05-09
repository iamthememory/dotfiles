# Settings for specific filetypes.
{ ...
}: {
  imports = [
    ./c.nix
    ./cfg.nix
    ./cmake.nix
    ./docker.nix
    ./dot.nix
    ./go.nix
    ./godot.nix
    ./green.nix
    ./haskell.nix
    ./json.nix
    ./lua.nix
    ./mail.nix
    ./markdown.nix
    ./moo.nix
    ./nix.nix
    ./perl.nix
    ./python.nix
    ./rst.nix
    ./ruby.nix
    ./rust.nix
    ./sh.nix
    ./tex.nix
    ./text.nix
    ./toml.nix
    ./vim.nix
    ./web.nix
    ./yaml.nix
  ];
}
