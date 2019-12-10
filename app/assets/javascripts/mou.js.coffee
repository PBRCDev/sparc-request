$ ->

$(document).on 'click', '.mou-yes-button', (event) ->
  event.preventDefault()
  $this = $(this)
  $('#submitRequest').addClass('disabled')

  $.ajax
    method: 'get'
    dataType: 'script'
    url: '/service_request/system_satisfaction_survey'
    data:
      srid: getSRId()
      forward: $this.prop('href')
