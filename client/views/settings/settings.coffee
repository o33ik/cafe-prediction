Template.settings.events
	'click .update-prediction-button': () ->
		Meteor.call 'updatePredictionModel'

	'click .predict-sales-button': () ->
		Meteor.call 'predictSales'