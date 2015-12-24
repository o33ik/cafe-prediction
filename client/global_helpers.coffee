UI.registerHelper "formatDate", (date, format) ->
    format = format || "DD.MM.YYYY"
    moment(date).format format


@getDateFromWeek = (params) ->
    date = moment()
    date.year params.year
    date.week params.week

    date