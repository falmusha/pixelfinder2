//= require rails-ujs
//= require turbolinks
//= require autocomplete

document.addEventListener('turbolinks:load', function() {
  var filters = document.querySelectorAll('#filters-form .filters-list .filter');
  var searchSubmitButton = document.querySelectorAll('#search-button button')[0];

  Array.prototype.forEach.call(filters, function(filterDiv, i) {
    (new Autocomplete(filterDiv)).attach();
  });

  searchSubmitButton.addEventListener('click', function(ev) {
    var button = ev.targetEvent;
    var searchForm = document.querySelectorAll('#filters-form')[0];
    searchForm.submit();
  });
});
