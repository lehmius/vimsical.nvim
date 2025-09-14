_default:
	just --list

check:
	nix flake check --all-systems

package:
	nix build --json --no-link --print-build-logs .

update:
	nix flake update
