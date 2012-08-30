# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$('.date-picker').datepicker
		format: 'yyyy-mm-dd'
		language: 'es'
		weekStart: 1
		autoclose: true
			
	$('.date-picker').on("mouseenter", () ->
		$(this).effect("highlight")
	)
			
	$('.date-picker').on('change', () ->
		$("#submit-date").fadeOut() unless $('.date-picker').val()
		$("#submit-date").fadeIn() if $('.date-picker').val()
	);