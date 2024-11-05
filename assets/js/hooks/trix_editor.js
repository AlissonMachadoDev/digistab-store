/**
 * @type {Object.<string, import("phoenix_live_view").ViewHook>}
 */
import Trix from "trix";

export const TrixEditor = {
  mounted() {
    const element = document.querySelector("trix-editor");
    element.editor.loadHTML(element.getAttribute("value") || "");
    element.editor.element.addEventListener("trix-change", (e) => {
      this.el.dispatchEvent(new Event("change", { bubbles: true }));
      this.pushEventTo(element, "validate", {type: "set-description", value: e.srcElement.innerHTML})
    });
    element.editor.element.addEventListener("trix-initialize", () => {
      element.editor.element.focus();
      var length = element.editor.getDocument().toString().length;
      window.setTimeout(() => {
        element.editor.setSelectedRange(length, length);
      }, 1);
    });
    this.handleEvent("updateContent", (data) => {
      element.editor.loadHTML(data.content || "");
    });
  },
};