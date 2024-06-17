import './environment.js';
import './cssinject.js';
import 'monaco-editor/esm/vs/editor/editor.main.js';

(function() {
    if (globalThis.monacoReadyHook && Array.isArray(globalThis.monacoReadyHook)) {
        globalThis.monacoReadyHook.forEach(callback => callback());
    }
    globalThis.monacoReadyHook = {isReady: true, push: function(...cbs) { cbs.forEach(callback => callback()); return this; }};
})();
