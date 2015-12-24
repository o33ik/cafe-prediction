Template.menuItemWithPredict.onCreated ->

Template.menuItemWithPredict.helpers
	menuItem: ->
		Template.instance().data.menuItem

	dailySales: ->
		menuItem = Template.instance().data.menuItem
		selectedWeekAndYear = Template.instance().data.selectedWeekAndYear
		selectedDate = moment getDateFromWeek selectedWeekAndYear
		
		getDailySalesForSelectedWeek menuItem, selectedDate



getDailySalesForSelectedWeek = (menuItem, selectedDate) ->

	dailySales = []

	startOfWeek = moment(selectedDate).startOf "week"
	endOfWeek = moment(selectedDate).endOf "week"

	day = startOfWeek
	while day < endOfWeek
		startOfDay = moment(day).startOf 'day'
		endOfDay = moment(day).endOf 'day'
		ds = DailySales.findOne({
			menuItemId: menuItem._id
			date:
				$lte: endOfDay.toDate()
				$gte: startOfDay.toDate()
		})
		if not ds
			ds = {}
			ds.date = startOfDay.toDate()
			ds.actualQuantity = '-'

		ds.predictedQuantity = ds.predictedQuantity || '-'
		dailySales.push ds
		day = startOfWeek.add 1, 'day'

	dailySales