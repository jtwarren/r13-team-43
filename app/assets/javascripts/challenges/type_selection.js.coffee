$(document).on 'ready page:load', ->
  $('form.challenge-type-selection input:radio').on 'change', ->
    form = $(@).closest('form')
    form.submit()
