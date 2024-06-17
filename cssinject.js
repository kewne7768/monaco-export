import { default as builtCssStr } from "./builtcss.builtcss";

const monacoCssUrl = URL.createObjectURL(new Blob([builtCssStr], { type: "text/css" }));
const css = document.createElement("link");
css.setAttribute("rel", "stylesheet");
css.setAttribute("type", "text/css");
css.setAttribute("href", monacoCssUrl);
// Due to potentially running in @run-at document-start context, document.head is not guaranteed to be available.
// documentElement isn't really correct, but alas.
(document.head ?? document.documentElement).appendChild(css);
