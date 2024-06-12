// MonacoEnvironment.globalAPI needs to be defined *at import time*.
// This is awkward to do without putting it into a seperate module of sorts.
// This currentScript situation will only work right if this is bundled, which it is.
(function() {
    let scriptUrl = document.currentScript?.src ?? null;
    if (!scriptUrl) {
        throw "Couldn't figure out where the monaco editor is being loaded from.";
    }
    let scriptDirUrl = scriptUrl.replace(/\/([^\/]*)$/, "");
    globalThis.MonacoEnvironment = {
        globalAPI: true,
        getWorkerUrl(_workerId, label) {
            switch (label) {
                case "javascript":
                case "typescript":
                    return `${scriptDirUrl}/ts.worker.js`;
                default:
                    return `${scriptDirUrl}/editor.worker.js`;
            }
        },
    };

    // Also load the stylesheet.
    let css = document.createElement("link");
    css.setAttribute("rel", "stylesheet");
    css.setAttribute("type", "text/css");
    css.setAttribute("href", `${scriptDirUrl}/monaco-export.css`);
    document.head.appendChild(css);
})();
