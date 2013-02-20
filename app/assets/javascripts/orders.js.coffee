# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#user_login').hide()
  $('#login_show_toggle').click ->
    $('#user_login').toggle('blind',500)
    $('#order_form').toggle('blind',500)
    return false
