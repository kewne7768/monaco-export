# Bundled/exported monaco-editor

This artifact was produced to make it possible to embed Monaco into a specific userscript that is developed in a 'traditional JavaScript' way.

A basic callback hook is implemented. You can load the produced bundle asynchronously and run something like this:

    globalThis.monacoReadyHook = (globalThis.monacoReadyHook ?? []).push(() => { yourStuffHere(); });

Your hook will be called after it's done loading, or immediately if it's already loaded.

This whole setup is janky. If you can use a bundler yourself, just do that.
