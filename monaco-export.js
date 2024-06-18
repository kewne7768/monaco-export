import './environment.js';
import './cssinject.js';
import 'monaco-editor/esm/vs/editor/editor.main.js';

(function() {
    let where = globalThis;
    if (typeof unsafeWindow !== "undefined") where = unsafeWindow;
    else if (typeof window !== "undefined") where = window;
    if (where.monacoReadyHook && Array.isArray(where.monacoReadyHook)) {
        where.monacoReadyHook.forEach(callback => callback());
    }
    where.monacoReadyHook = {isReady: true, push: function(...cbs) { cbs.forEach(callback => callback()); return this; }};
})();
