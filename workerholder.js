// This contains the web workers for monaco's background TypeScript processing.
// This must fit into the single file to fit within an @require statement, so we must pre-process it.
// Absolutely horrifying...

import { default as tsWorkerStr } from "./ts.workerjs";
import { default as editorWorkerStr } from "./editor.workerjs";

const tsWorkerUrl = URL.createObjectURL(new Blob([tsWorkerStr], { type: "text/javascript" }));
const editorWorkerUrl = URL.createObjectURL(new Blob([editorWorkerStr], { type: "text/javascript" }));

export { tsWorkerUrl, editorWorkerUrl };

