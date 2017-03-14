/*
  new Autocomplete(div) expect the following dom structure
  <div>
    <input class="visible" />
    <div class="autocomplete">
      <input class="shadow" />
      <ul class='list'>
        <li></li>
        ...
        <li></li>
      </ul>
    </div>
  </div>
*/
var Autocomplete = (function() {

  function Autocomplete(div) {
    this.div = div;
    this.visbleInput = undefined;
    this.shadowInput = undefined;
    this.ul = undefined;
    this.selectedIndex = -1;
    this.visibleList = {};
    this.init();
  }

  Autocomplete.prototype.init = function() {
    var visbleInputQuery = this.div.querySelectorAll('input.visible');
    if (visbleInputQuery.length == 1) {
      this.visbleInput = visbleInputQuery[0];
    }

    var shadowInputQuery = this.div.querySelectorAll('.autocomplete input.shadow');
    if (shadowInputQuery.length == 1) {
      this.shadowInput = shadowInputQuery[0];
    }

    var ulQuery = this.div.querySelectorAll('.autocomplete ul.list');
    if (ulQuery.length == 1) {
      this.ul = ulQuery[0];
    }
  };

  Autocomplete.prototype.attach = function() {
    if (this._isDivValid() == false)  {
      return;
    }

    this.ul.addEventListener('click', this._onClick.bind(this));
    this.visbleInput.addEventListener('keyup',
                                      this._onInputKeyupEvent.bind(this));
  };

  Autocomplete.prototype._isDivValid = function() {
    return this.visbleInput != undefined
           && this.shadowInput != undefined
           && this.ul != undefined;
  };

  Autocomplete.prototype._onClick = function(event) {
    if (event.target.tagName != 'LI') {
      return;
    }

    this.visbleInput.value = event.target.textContent;
    this.shadowInput.value = event.target.id;
    this._hide();
  };

  Autocomplete.prototype._onInputKeyupEvent = function(event) {
    var visibleIndex = 0;

    switch(event.keyCode) {
      case 9:  // TAB KEY
      case 27: // ESCAPE KEY
        this._hide();
        return;
      case 13:  // ENTER KEY
        this._clickSelected();
        return;
      case 38: // UP ARROW KEY
        if (this.selectedIndex > 0) {
          this.selectedIndex--;
        }
        break;
      case 40: // DOWN ARROW KEY
        if (this.selectedIndex < this.ul.children.length) {
          this.selectedIndex++;
        }
        break;
    }

    this._show();

    for (var i = 0; i < this.ul.children.length; i++) {
      var needle = this.visbleInput.value.trim().toLowerCase();
      var haystack = this.ul.children[i].textContent.trim().toLowerCase();

      if (this._fuzzySearchMatch(needle, haystack) == true) {
        if (visibleIndex == this.selectedIndex) {
          this.ul.children[i].classList.add('shown', 'selected');
        } else {
          this.ul.children[i].classList.add('shown');
          this.ul.children[i].classList.remove('selected');
        }
        visibleIndex++;
      } else {
        this.ul.children[i].classList.remove('shown', 'selected');
      }
    }
  };

  Autocomplete.prototype._clickSelected = function(event) {
    var selected = this.ul.querySelectorAll('li.selected');
    if (selected.length == 1) {
      var event = new MouseEvent('click', {
        'view': window,
        'bubbles': true,
        'cancelable': true
      });
      selected[0].dispatchEvent(event);
    }
    this._hide();
  };

  Autocomplete.prototype._show = function() {
    this.ul.classList.add('shown');
  };

  Autocomplete.prototype._hide = function(event) {
    this.ul.classList.remove('shown');
    this.selectedIndex = 0;
  };

  Autocomplete.prototype._fuzzySearchMatch = function(needle, haystack) {
    // courstey of https://github.com/bevacqua/fuzzysearch
    var hlen = haystack.length;
    var nlen = needle.length;
    if (nlen > hlen) {
      return false;
    }
    if (nlen === hlen) {
      return needle === haystack;
    }
    outer: for (var i = 0, j = 0; i < nlen; i++) {
      var nch = needle.charCodeAt(i);
      while (j < hlen) {
        if (haystack.charCodeAt(j++) === nch) {
          continue outer;
        }
      }
      return false;
    }
    return true;
  };

  return Autocomplete;
})();
