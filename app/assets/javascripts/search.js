$(document).on('ajax:success', '.search', function(event, data, status) {
  if (status == 'success') {
    $('.results').empty().append(data);
  } else {
    $('.results').empty().append('<div>No results found</div>');
  }
});
