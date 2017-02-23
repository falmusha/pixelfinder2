/*
  new Autocomplete(divElement) expect the following dom structure
  <div>
    <input />
    <ul class='autocomplete-list'>
      <li></li>
      ...
      ...
      <li></li>
    </ul>
  </div>
*/
var Autocomplete = (function() {

  function Autocomplete(div) {
    this.divElement = div;
  }

  Autocomplete.prototype.attach = function() {
    if (this._isDivValid() == false)  {
      return;
    }

    var inputElement = this.divElement.querySelectorAll('input')[0];

    inputElement.addEventListener('keyup', this._onInputKeyupEvent.bind(this));
    inputElement.addEventListener('focusout', this._hide.bind(this));
  };

  Autocomplete.prototype._isDivValid = function() {
    // must contain only 1 input
    var inputElement = this.divElement.querySelectorAll('input');
    if (inputElement.length != 1) {
      return false;
    }

    // must contain only 1 autocomplete list
    var ulElement = this.divElement.querySelectorAll('ul.autocomplete-list');
    if (ulElement.length != 1) {
      return false;
    }

    return true;
  };

  Autocomplete.prototype._onInputKeyupEvent = function(event) {
    if (event.keyCode == 27) {
      // ESCAPE KEY
      this._hide();
      return;
    }

    var inputElement = event.target;
    var ulElement = inputElement.nextElementSibling;

    this._show();

    for (var i = 0; i < ulElement.children.length; i++) {
      var needle = inputElement.value.trim().toLowerCase();
      var haystack = ulElement.children[i].textContent.trim().toLowerCase();

      if (this._fuzzySearchMatch(needle, haystack) == true) {
        ulElement.children[i].classList.add('shown');
      } else {
        ulElement.children[i].classList.remove('shown');
      }
    }
  };

  Autocomplete.prototype._show = function() {
    var ulElement = this.divElement.querySelectorAll('ul.autocomplete-list')[0];
    ulElement.classList.add('shown');
  };

  Autocomplete.prototype._hide = function() {
    var ulElement = this.divElement.querySelectorAll('ul.autocomplete-list')[0];
    ulElement.classList.remove('shown');
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