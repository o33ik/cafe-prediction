Future = Npm.require "fibers/future"
fs = Npm.require "fs"

Meteor.methods
  "importDataFromObj": () ->
    fillCollectionFromArray "dailySales"
    fillCollectionFromArray "menuItems"
    fillCollectionFromArray "weather"


  "importDataFromJSON": (collectionsNames) ->
    collectionsNames.forEach (collectionName) ->
      fillCollectionFromFile collectionName
    true

  "exportDataIntoJSON": (collectionsNames) ->
    collectionsNames.forEach (collectionName) ->
      writeCollectionIntoFile collectionName

  # deprecated
  "improveWeatherHistory": ->
    weatherHistory = Weather.find().fetch();
    groupedWeather = _.groupBy weatherHistory, "main"
    groupedWeatherKeys = _.keys groupedWeather

    groupedWeatherKeys.forEach (key) ->
      newValue = getNewWeatherDesc key
      Weather.update {main: key}, {$set: {main: newValue}}, {multi: true}
    true

  "improveWeatherDateField": ->
    Weather.find().forEach (item) ->
      Weather.update {_id: item._id}, 
        $set: date: new Date item.date 
  true

fillCollectionFromArray = (arrayName) ->
  console.log arrayName
  collection = Mongo.Collection.get arrayName
  collection.remove {}
  data = startData[arrayName]
  data.forEach (item) ->
    if item.date
      item.date = new Date item.date
    collection.insert item

fillCollectionFromFile = (collectionName) ->
  console.log collectionName
  collection = Mongo.Collection.get collectionName
  collection.remove {}
  future = new Future
  path = process.env["PWD"] + "/server/utils/data/#{collectionName}.json"
  fs.readFile path, (err, data) ->
    data = JSON.parse data
    future.return data
  data = future.wait()
  data.forEach (item) ->
    if item.date
      item.date = new Date item.date
    collection.insert item

writeCollectionIntoFile = (collectionName) ->
  console.log collectionName
  collection = Mongo.Collection.get collectionName
  items = collection.find().fetch()
  future = new Future
  path = process.env["PWD"] + "/server/utils/data/#{collectionName}.json"
  buffer = new Buffer JSON.stringify items
  fs.writeFileSync path, buffer

# deprecated
getNewWeatherDesc = (key) ->
  result = ""
  switch key
    when "Patchy rain nearby"
      result = "Rain"
    when "Light rain shower"
      result = "Rain"
    when "Sunny"
      result = "Clear"
    when "Heavy rain"
      result = "Rain"
    when "Overcast"
      result = "Clouds"
    when "Partly Cloudy"
      result = "Clouds"
    when "Cloudy"
      result = "Clouds"
    when "Moderate rain"
      result = "Rain"
    when "Light rain"
      result = "Rain"
    when "Patchy light rain in area with thunder"
      result = "Thunderstorm"
    when "Patchy light drizzle"
      result = "Drizzle"
    when "Light drizzle"
      result = "Drizzle"
    when "Thundery outbreaks in nearby"
      result = "Thunderstorm"
    when "Moderate or heavy rain shower"
      result = "Rain"
    when "Torrential rain shower"
      result = "Rain"
    when "Moderate or heavy rain in area with thunder"
      result = "Thunderstorm"
    when "Patchy light rain"
      result = "Rain"
  result