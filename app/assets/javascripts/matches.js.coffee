$(document).ready ->
  $('#show-newm').click (event) ->
    event.preventDefault()
    $(this).hide()
    $('#newm').show()

