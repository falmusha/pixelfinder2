//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require autocomplete

document.addEventListener('turbolinks:load', function () {
  var filters = document.querySelectorAll('#filters-form .filters-list .filter');

  Array.prototype.forEach.call(filters, function(filterDiv, i) {
    (new Autocomplete(filterDiv)).attach();
  });
});