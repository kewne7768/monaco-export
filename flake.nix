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
          allowSubstitutes = false; # This is more of a "what are you doing?????"
          pname = "monaco-export";
          version = pkgLockJson.packages."node_modules/monaco-editor".version;
          src = ./.;
          monacoTarGz = getTarGz pkgLockJson.packages."node_modules/monaco-editor";
          postUnpack = ''
            cp -r $sourceRoot $TMP/root
            mkdir -p $TMP/root/node_modules/monaco-editor
            tar -C "$TMP/root/node_modules/monaco-editor" --strip-components 1 -xzf $monacoTarGz
          '';
          installPhase = ''
            cd "$TMP/root"
            # Minify the workers
            esbuild node_modules/monaco-editor/esm/vs/language/typescript/ts.worker.js --minify --bundle --target=es2022 --outfile=$TMP/root/ts.workerjs
            esbuild node_modules/monaco-editor/esm/vs/editor/editor.worker.js --minify --bundle --target=es2022 --outfile=$TMP/root/editor.workerjs

            # Build pass 1: we really only care about the CSS. This version will inject a placeholder file while also building the real one.
            touch $TMP/root/builtcss.builtcss
            esbuild monaco-export.js \
              --minify --bundle --target=es2022 \
              --loader:.ttf=dataurl --loader:.workerjs=text --loader:.builtcss=text \
              --outdir=$TMP/css-pass
            mv -f $TMP/css-pass/monaco-export.css $TMP/root/builtcss.builtcss

            # Build pass 2: real CSS injector included! This one goes in $out.
            esbuild monaco-export.js \
              --minify --bundle --target=es2022 \
              --loader:.ttf=dataurl --loader:.workerjs=text --loader:.builtcss=text \
              --outdir=$out
            # Delete extranous now-bundled CSS file
            rm -f $out/*.css
          '';
          buildInputs = with pkgs; [ esbuild ];
        };
      };
    };
  #esbuild monaco-export.js ts.worker=node_modules/monaco-editor/esm/vs/language/typescript/ts.worker.js editor.worker=node_modules/monaco-editor/esm/vs/editor/editor.worker.js --minify --bundle --target=es2022 --loader:.ttf=file --outdir=result
}
