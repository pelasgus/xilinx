# flake_qemu.nix
# author: D.A.Pelasgus

{
  description = "QEMU flake";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-21.11;

    qemu.url = github:NixOS/nixpkgs/nixos/modules/virtualisation/qemu/qemu-vanilla.nix;
    qemu.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, qemu }: {
    nixosConfigurations.x86_64-linux = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ qemu.nixosModules.qemu ];
    };

    nixosConfigurations.aarch64-linux = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ qemu.nixosModules.qemu ];
    };
  };
}
