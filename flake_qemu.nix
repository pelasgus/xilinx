# flake.nix
# author: D.A.Pelasgus

{
  description = "QEMU Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = flake-utils.lib.eachDefaultSystem (system:
    let
      nixpkgs = import inputs.nixpkgs { inherit system; };
      flake-utils = inputs.flake-utils.lib;

      qemu = nixpkgs.callPackage ./qemu.nix { };
    in
    {
      packages.x86_64-linux = qemu;
      packages.aarch64-linux = qemu;
      packages.x86_64-darwin = qemu;
      defaultPackage.x86_64-linux = qemu;
      defaultPackage.aarch64-linux = qemu;
      defaultPackage.x86_64-darwin = qemu;
    }
  );
}
