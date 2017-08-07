#= require ./calendar_date

{strftime, translate, getI18nValue} = LocalTime

class LocalTime.RelativeTime
  constructor: (@date) ->
    @calendarDate = LocalTime.CalendarDate.fromDate(@date)

  toString: ->
    if time = @toTimeElapsedString()
      translate("time.elapsed", {time})
    else if date = @toWeekdayString()
      time = @toTimeString()
      translate("datetime.at", {date, time})
    else
      translate("date.on", date: @toDateString())

  toTimeOrDateString: ->
    if @calendarDate.isToday()
      @toTimeString()
    else
      @toDateString()

  toTimeElapsedString: ->
    ms = new Date().getTime() - @date.getTime()
    seconds = Math.round ms / 1000
    minutes = Math.round seconds / 60
    hours = Math.round minutes / 60

    if ms < 0
      null
    else if seconds < 10
      time = translate("time.second")
      translate("time.singular", {time})
    else if seconds < 45
      "#{seconds} #{translate("time.seconds")}"
    else if seconds < 90
      time = translate("time.minute")
      translate("time.singular", {time})
    else if minutes < 45
      "#{minutes} #{translate("time.minutes")}"
    else if minutes < 90
      time = translate("time.hour")
      translate("time.singularAn", {time})
    else if hours < 24
      "#{hours} #{translate("time.hours")}"
    else
      ""

  toWeekdayString: ->
    switch @calendarDate.daysPassed()
      when 0
        translate("date.today")
      when 1
        translate("date.yesterday")
      when -1
        translate("date.tomorrow")
      when 2,3,4,5,6
        strftime(@date, "%A")
      else
        ""

  toDateString: ->
    format = if @calendarDate.occursThisYear()
      getI18nValue("date.formats.thisYear")
    else
      getI18nValue("date.formats.default")

    strftime(@date, format)

  toTimeString: ->
    strftime(@date, getI18nValue("time.formats.default"))
