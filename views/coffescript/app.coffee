$ ->
  new_ship_div_class = '.new_ship'
  $new_ship_form = $(new_ship_div_class).first().clone()
  $('.add_ship').click( ->
    $(@).closest('.row').before($new_ship_form.clone())
  )
