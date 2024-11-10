/**
 * @type {Object.<string, import("phoenix_live_view").ViewHook>}
 * 
 * CustomCounterInput Hook
 * 
 * Manages a number input with increment/decrement buttons.
 * - Prevents the value from going below zero.
 * - Fires a `change` event whenever the value is updated.
 * 
 * To use, add `data-action="increment"` and `data-action="decrement"` attributes to your buttons.

 */

export const CustomCounterInput = {
    mounted() {
        function decrement(e) {
            const btn = e.target.parentNode.parentElement.querySelector(
                'button[data-action="decrement"]'
            );
            const target = btn.nextElementSibling;
            let value = Number(target.value);
            value--;
            target.value = value;
            if (value <= 0) {
                btn.setAttribute("disabled", "disabled");
            } 
            target.dispatchEvent(new Event("change", { stock: value }));
        }

        function increment(e) {
            const btn = e.target.parentNode.parentElement.querySelector(
                'button[data-action="decrement"]'
            );
            const target = btn.nextElementSibling;
            let value = Number(target.value);
            value++;
            target.value = value;


        const dec = e.target.parentNode.parentElement.querySelector(
            'button[data-action="decrement"]'
        );

            dec.removeAttribute("disabled");

            target.dispatchEvent(new Event("change", { bubbles:true }));
        }

        const decrementButtons = document.querySelectorAll(
            `button[data-action="decrement"]`
        );

        const incrementButtons = document.querySelectorAll(
            `button[data-action="increment"]`
        );

        console.log(this.el)

        const btn = this.el.parentNode.parentElement.querySelector(
            'button[data-action="decrement"]'
        );

        if(Number(this.el.value) <= 0) {
        btn.setAttribute("disabled", "disabled");
        }

        decrementButtons.forEach(btn => {
            btn.addEventListener("click", decrement);
        });

        incrementButtons.forEach(btn => {
            btn.addEventListener("click", increment);
        });
    }
}