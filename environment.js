// MonacoEnvironment.globalAPI needs to be defined *at import time*.
// This is awkward to do without putting it into a seperate piece of code of sorts.
// This currentScript situation will only work right if this is bundled, which it is.
import { tsWorkerUrl, editorWorkerUrl } from "./workerholder";
(function() {
    globalThis.MonacoEnvironment = {
        globalAPI: true,
        getWorkerUrl(_workerId, label) {
            switch (label) {
                case "javascript":
                case "typescript":
                    return tsWorkerUrl;
                default:
                    return editorWorkerUrl;
            }
        },
    };
})();
