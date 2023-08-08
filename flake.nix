{
  description = "Agda library search engine";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };
  outputs =
    { self
    , nixpkgs
    , rust-overlay
    , ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
        config = {
          #          allowUnfree = true;
        };
      };
      toolchain = pkgs.rust-bin.fromRustupToolchainFile ./toolchain.toml;
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        name = "agda-search dev environment";
        packages = [
          toolchain
          pkgs.rust-analyzer-unwrapped
          pkgs.trunk
        ];
        RUST_SRC_PATH = "${toolchain}/lib/rustlib/src/rust/library";
      };
    };
}
