# Cursed Nix flake
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      pkgLockJson = builtins.fromJSON (builtins.readFile ./package-lock.json);
      getTarGz =
        { resolved, integrity, ... }:
        pkgs.fetchurl {
          url = resolved;
          hash = integrity;
        };
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
      devShells.${system}.shell = pkgs.mkShell {
        buildInputs = with pkgs; [
          nodejs
          esbuild
        ];
      };
      packages.${system} = {
        default = pkgs.stdenv.mkDerivation {
          pname = "monaco-export";
          version = pkgLockJson.packages."node_modules/monaco-editor".version;
          src = ./.;
          monacoTarGz = getTarGz pkgLockJson.packages."node_modules/monaco-editor";
          postUnpack = ''
            mkdir -p $sourceRoot/node_modules/monaco-editor
            tar -C "$sourceRoot/node_modules/monaco-editor" --strip-components 1 -xzf $monacoTarGz
          '';
          installPhase = ''
            esbuild monaco-export.js \
              ts.worker=node_modules/monaco-editor/esm/vs/language/typescript/ts.worker.js \
              editor.worker=node_modules/monaco-editor/esm/vs/editor/editor.worker.js \
              --minify --bundle --target=es2017 --loader:.ttf=file --outdir=$out
          '';
          buildInputs = with pkgs; [ esbuild ];
        };
      };
    };
  #esbuild monaco-export.js ts.worker=node_modules/monaco-editor/esm/vs/language/typescript/ts.worker.js editor.worker=node_modules/monaco-editor/esm/vs/editor/editor.worker.js --minify --bundle --target=es2017 --loader:.ttf=file --outdir=result
}
