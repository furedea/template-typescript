{
  description = "";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, nixpkgs-unstable, ... }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              commitlint
              deadnix
              # lefthook before 2.1.6 runs hooks under a pty, which agent sandboxes deny.
              nixpkgs-unstable.legacyPackages.${system}.lefthook
              ls-lint
              nixfmt
              nodejs_24
              pnpm
              statix
            ];
          };
        }
      );
    };
}
