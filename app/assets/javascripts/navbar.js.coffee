initializeAutocomplete = -> 
  $('#navbar_search').autocomplete
    min_length: 2,
    source: 'search/autocomplete'

$(document).ready(initializeAutocomplete)
$(document).on('page:load', initializeAutocomplete)