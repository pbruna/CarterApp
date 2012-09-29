# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$('.date-picker').datepicker
		format: 'yyyy-mm-dd'
		language: 'es'
		weekStart: 1
		autoclose: true
		
	$('#toggle_all_dst_emails').click () ->
		$("#rest_dst_emails").fadeToggle()