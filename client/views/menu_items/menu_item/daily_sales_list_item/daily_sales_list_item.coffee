Template.dailySalesListItem.helpers
	date: ->
		Template.instance().data.dailySale.date
	actualQuantity: ->
		Template.instance().data.dailySale.actualQuantity || 0
	predictedQuantity: ->
		Template.instance().data.dailySale.predictedQuantity || "-"