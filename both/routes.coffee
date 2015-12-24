Router.configure layoutTemplate: "masterLayout"

Router.map ->
  @route "menuItems",
    path: "/menuItems"
    template: "menuItems"
    waitOn: ->
      @subscribe "allMenuItems"
  
  @route "settings",
    path: "/settings"
    template: "settings"
  
  @route "menuItemView",
    path: "/menuItems/:id"
    template: "menuItemView"
    waitOn: ->
      @subscribe "menuItem", @params.id
  
  @route "prediction",
    path: "/prediction/:week?/:year?"
    template: "predictionView"
    waitOn: ->
      selectedWeekAndYear = week: @params.week, year: @params.year
      [
        @subscribe "weeklyDailySales", selectedWeekAndYear
        @subscribe "allMenuItems"
        @subscribe "weeklyWeather", selectedWeekAndYear 
      ]
    data: ->
      selectedWeekAndYear: week: @params.week, year: @params.year

  return

