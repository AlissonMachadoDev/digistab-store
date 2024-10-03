export const IntegerPriceInput = {
  mounted() {
    this.el.addEventListener("focus", e => {
      var val = this.el.value;
      if(val == "0,00") {
        this.el.value = '';
      }
    });
    this.el.addEventListener("focusout", e => {
      var val = this.el.value;
      if(val == "") {
        this.el.value = '0,00'; 
      }
    });
    this.el.addEventListener("input", e => {
      let str = this.el.value;
      str = str.replaceAll(/[^0-9]/g, "");
      while(str.length < 3) {
        str = `0${str}`;
      }
      if (str.length > 3 && str.at(0) == "0") {
        str = str.slice(1, str.length)
      }
      let match = str.replace(/\D/g, "").match(/^(\d+)(\d{2})$/);

      if(match) {
        if (this.el.getAttribute("currency") == "$") {
          this.el.value = `${match[1]}.${match[2]}`;
        } else {
          this.el.value = `${match[1]},${match[2]}`;
        }
      }
    });
    this.handleEvent("reset-field", ({field_id, price}) => {
      let str = price.toString()
      let field = document.getElementById(field_id)
      str = str.replaceAll(/[^0-9]/g, "");
      while(str.length < 3) {
        str = `0${str}`;
      }
      if (str.length > 3 && str.at(0) == "0") {
        str = str.slice(1, str.length)
      }
      let match = str.replace(/\D/g, "").match(/^(\d+)(\d{2})$/);

      if(match) {
        if (field.getAttribute("currency") == "$") {
          field.value = `${match[1]}.${match[2]}`;
        } else {
          field.value = `${match[1]},${match[2]}`;
        }
      }
    })
  },
};

