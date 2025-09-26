# Bundled/exported single-file monaco-editor

This artifact was produced to make it possible to embed Monaco into a specific userscript that is developed in a 'traditional JavaScript' way.

To be able to pre-load this, `@require` effectively requires everything to be stuffed into a single .js.

Annoying part 1: getting it to expose its `monaco` API in the window, instead of doing it via modules. Loading the AMD version _would_ work because it's special-cased to do that anyway, but otherwise, you need MonacoEnvironment set _before_ it's loaded.

Annoying part 2: You can't really bundle the AMD version, and there's at least the web workers and CSS to worry about (and also the "codicon" font but we can easily embed that with a data: URL).

So we build it via ESBuild, and then copy that built CSS, and rebuild it _again_ with a generic CSS injector.

And this is done with Nix because I'm silly like that. (You could say this whole thing is a learning exercise. (In learning how to do things badly.))

The end result is a single ~10MB file (~2.5MB zstd).

## Dynamic load hook

In case you end up loading this dynamically, a basic callback hook is implemented. You can load the produced bundle asynchronously and run something like this to wait until it's ready:

    globalThis.monacoReadyHook = (globalThis.monacoReadyHook ?? []).push(() => { yourStuffHere(); });

Your hook will be called after it's done loading, or immediately if it's already loaded. You'll have access to the `monaco` API in `globalThis` and/or `window` and/or `unsafeWindow` at that time, and can do [all the normal things you can do with it](https://microsoft.github.io/monaco-editor/).

## Jank

The only warranty on this setup is the fact that it's janky and barely works. No other warranty is provided or implied.
