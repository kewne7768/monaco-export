import './environment.js';
import 'monaco-editor/esm/vs/editor/editor.api.js';

(function() {
    if (globalThis.monacoReadyHook && Array.isArray(globalThis.monacoReadyHook)) {
        globalThis.monacoReadyHook.forEach(callback => callback());
    }
    globalThis.monacoReadyHook = {push: function(...cbs) { cbs.forEach(callback => callback()); return this; }};
})();
