Meteor.methods
  "deleteMenuItem": (id)->
    check id, Match.Where (id) ->
      check id, String
      !!MenuItems.findOne _id: id

    MenuItems.remove _id: id
    DailySales.remove menuItemId: id

  "updateWeatherForecast": (numberOfDays, city, countryCode) ->
    numberOfDays = numberOfDays || 8
    city = city || "Melbourne"
    countryCode = countryCode || "AU"

    check city, String
    check countryCode, String
    check numberOfDays, Match.Where (val) ->
      check val, Number
      return val <= 16

    location = "#{city},#{countryCode}"
    
    apiRequestString = "http://api.openweathermap.org/data/2.5/forecast/daily?q=#{location}&mode=json&units=metric&cnt=#{numberOfDays}&appid=2de143494c0b295cca9337e1e96b00e0" 
    weatherForecast = Meteor.http.call "GET", apiRequestString
    
    weatherForecast.data.list.forEach (item) ->
      parsedDate = parseWeatherItem item
      startOfTheDay = moment(parsedDate.date).startOf("day").toDate();
      endOfTheDay = moment(parsedDate.date).endOf("day").toDate();

      Weather.upsert {date: {$gte: startOfTheDay, $lte: endOfTheDay}},
        {$set: date: startOfTheDay, main: parsedDate.main, temp: parsedDate.temp}

  "predictSalesForMenuItem": (menuItemId, numberOfDays) ->
    check numberOfDays, Match.Where (val) ->
      check val, Number
      return val <= 16
    check menuItemId, Match.Where (id) ->
      check id, String
      !!MenuItems.findOne _id: id

    # I add 1 day, because, I need prediction since tomorrow
    startDate = moment().startOf("day").add 1, "days"
    endDate = moment().startOf("day").add numberOfDays + 1, "days"

    weather = Weather.find date: $gte: startDate.toDate(), $lte: endDate.toDate()

    Meteor.call "makeRequestToPredictionServer", menuItemId, weather.fetch()

  "updatePredictionModel": () ->

    # Add http request to prediction server above 

  "predictSales": (numberOfDays) ->
    numberOfDays = numberOfDays || 16
    check numberOfDays, Match.Where (val) ->
      check val, Number
      return val <=16

    Meteor.call 'updateWeatherForecast', numberOfDays, "Melbourne", "AU"

    # Predict sales for each menuItem
    MenuItems.find().forEach (item) ->
      Meteor.call "predictSalesForMenuItem", item._id, numberOfDays

    true

  "removePredictedData": ->
    today = moment().startOf "day"

    DailySales.remove date: $lte today.toDate()
    Weather.remove date: $lte today.toDate()

  'makeRequestToPredictionServer': (menuItemId, weather)->

    menuItems = []
    formattedWeather = []
    weather.forEach (weatherItem) ->
      menuItem = {
        _id: 'qwerty'
        'actualQuantity': 0
        date: moment(weatherItem.date).toISOString()
        menuItemId: menuItemId
      }
      weatherItem.date = menuItem.date
      menuItems.push menuItem
      formattedWeather.push weatherItem

    console.log "menuItems:\n", menuItems, "\nformattedWeather:\n", formattedWeather

    data = 
      project_id: '450a70c8-1ef3-46de-a648-1d04124bb1e0'
      daily_sales: menuItems
      weather: formattedWeather
    token = '8fa889887114bfbd11ad7dfab563d0c3daa84356'
    # Auth Token (Вкладка Profile)
    options = 
      headers: Authorization: 'Token ' + token
      data: data
    url = 'https://vanga.pythonanywhere.com/projects/predict/'
    
    result = undefined
    try
      result = HTTP.call 'POST', url, options
    catch e
      return 'suka'
    return result

parseWeatherItem = (item) ->
  parsedItem = {}

  # because, API returns clipped date
  parsedItem.date = moment(parseInt item.dt + "000").startOf("day").toDate()
  parsedItem.main = item.weather[0].main
  parsedItem.temp = calculateAverageTemp item.temp

  parsedItem

calculateAverageTemp = (temp)->
  sum = temp.day + temp.eve + temp.morn + temp.night
  Math.round sum / 4