Meteor.publish "allMenuItems", ->
  MenuItems.find()

# publish menu item, and related dailySales
Meteor.publishComposite "menuItem", (id) -> 
  {
    find: ->
      MenuItems.find _id: id
    children: [
      find: (menuItem) ->
        DailySales.find menuItemId: menuItem._id
    ]
  }

Meteor.publish "weeklyDailySales", (weekDate) ->
  date = getDateFromWeek weekDate

  startOfWeek = moment date.startOf 'week'
  endOfWeek = moment date.endOf 'week'

  DailySales.find date: $lte: endOfWeek.toDate(), $gte: startOfWeek.toDate()

Meteor.publish "weeklyWeather", (weekDate) ->
  date = getDateFromWeek weekDate

  startOfWeek = moment date.startOf 'week'
  endOfWeek = moment date.endOf 'week'

  Weather.find date: $lte: endOfWeek.toDate(), $gte: startOfWeek.toDate()

@getDateFromWeek = (params) ->    
    date = moment()
    date.year params.year
    date.week params.week

    date