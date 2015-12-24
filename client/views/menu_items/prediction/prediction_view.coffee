Template.predictionView.onCreated ->

	@selectedWeekAndYear = new ReactiveVar @data.selectedWeekAndYear

	true

Template.predictionView.onRendered ->

	$datepicker = @$('.weekpicker')
	
	# define the datepicker
	dp = $datepicker.datepicker
		weekStart: 1
		calendarWeeks: true

	# get datepicker object
	datepicker = $datepicker.data "datepicker"

	selectedDate = getDateFromWeek @selectedWeekAndYear.get()

	# Set current date in datepicker
	datepicker.setDate selectedDate.toDate()

	# Set current week in datepicker input(for display)
	startOfWeek = selectedDate.startOf("week").format 'DD/MM/YYYY'
	endOfWeek = selectedDate.endOf("week").format 'DD/MM/YYYY'
	$datepicker.val "#{startOfWeek} - #{endOfWeek}"

	#define event for dp
	dp.on 'changeDate', (e) ->
		selectedDate = moment e.date

		datepicker.hide()
		Router.go 'prediction', week: selectedDate.week(), year: selectedDate.year()

	true


Template.predictionView.helpers
	menuItems: ->
		MenuItems.find()

	daysOfWeek: ->
		selectedWeekAndYear = Template.instance().selectedWeekAndYear.get()
		selectedDate = getDateFromWeek selectedWeekAndYear

		day = moment(selectedDate).startOf("week")
		days = []
		i = 0

		while i < 7
			days.push day.format "ddd, DD/MM"
			day = day.add(1, "days")

			i++
			
		days

	selectedWeekAndYear: ->
		Template.instance().selectedWeekAndYear.get()