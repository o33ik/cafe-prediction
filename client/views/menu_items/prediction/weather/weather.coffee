Template.weather.onRendered ->

Template.weather.helpers
	weatherForWeek: () ->
		selectedWeekAndYear = Template.instance().data.selectedWeekAndYear

		selectedDate = getDateFromWeek selectedWeekAndYear

		startOfWeek = moment(selectedDate).startOf "week"
		endOfWeek = moment(selectedDate).endOf "week"

		weather = []

		day = startOfWeek
		while day < endOfWeek
			startOfDay = moment(day).startOf 'day'
			endOfDay = moment(day).endOf 'day'
			weatherItem = Weather.findOne({
				date:
					$lte: endOfDay.toDate()
					$gte: startOfDay.toDate()
			})
			if weatherItem
				weatherItem.temp += "\u00B0"
			else
				weatherItem = {}
				weatherItem.date = startOfDay.toDate()
				weatherItem.temp = '-'
				weatherItem.main = 'N/A'

			weather.push weatherItem
			day = startOfWeek.add 1, 'day'

		weather