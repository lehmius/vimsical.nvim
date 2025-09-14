# Credit for original flake.nix goes to github:ALT-F4-LLC/thealtf4stream.nvim
{
  description = "Neovim configuration by lehmius";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: 
    let
      forAllSystems = nixpkgs.lib.genAttrs [ 
        "aarch64-darwin"
	"aarch64-linux"
	"x86_64-darwin"
	"x86_64-linux"
      ];
  in {
    lib = import ./lib { inputs = self.inputs; };
    packages = forAllSystems (system: {
      default = self.lib.mkVimPlugin { inherit system; };
    });

    devShells = forAllSystems (system: {
      default = nixpkgs.legacyPackages.${system}.mkShell {
        buildInputs = [
	  nixpkgs.legacyPackages.${system}.just
	];
      };
    });

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
