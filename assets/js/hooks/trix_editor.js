/**
 * @type {Object.<string, import("phoenix_live_view").ViewHook>}
 *
 * TrixEditor Hook
 * 
 * Connects a Trix rich text editor with your app.
 * - Loads initial content and tracks changes.
 * - Sends updates back to the server in real-time.
 * 
 * Great for forms needing formatted text input.
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