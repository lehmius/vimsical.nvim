# Code originally by ALT-F4-LLC at https://github.com/ALT-F4-LLC/thealtf4stream.nvim/blob/main/lib/default.nix
{ inputs}: let
  inherit (inputs.nixpkgs) legacyPackages;
in rec {
  mkVimPlugin = { system }: let
    inherit (pkgs) vimUtils;
    inherit (vimUtils) buildVimPlugin;
    pkgs = legacyPackages.${system};
  in
    buildVimPlugin {
      buildInputs = with pkgs; [];
      name = "vimsical";
      src = ../.;
      dependencies = with pkgs.vimPlugins; [
      ];

      vimSkipModules = [
        "init"
	"notify.integrations.fzf"
      ];

      postInstall = ''
        rm -rf $out/.gitignore
	rm -rf $out/LICENSE
	rm -rf $out/README.md
	rm -rf $out/flake.lock
	rm -rf $out/flake.nix
	rm -rf $out/justfile
	rm -rf $out/lib
      '';
    };

    mkNeovimPlugins = { system }: let
      inherit (pkgs) vimPlugins;
      pkgs = legacyPackages.${system};
      vimsical-nvim = mkVimPlugin { inherit system; };
      in
        with vimPlugins; [
	  vimsical-nvim
	];
    
    mkExtraConfig = ''
      lua << EOF
        require 'vimsical'.init()
      EOF
    '';

    mkHomeManager = { system }: let
      extraConfig = mkExtraConfig;
      plugins = mkNeovimPlugins { inherit system; };
    in {
      inherit extraConfig plugins;
      defaultEditor = true;
      enable = true;
    };

}
