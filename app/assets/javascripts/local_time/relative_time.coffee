#= require ./calendar_date

{strftime, translate, getI18nValue} = LocalTime

class LocalTime.RelativeTime
  constructor: (@date) ->
    @calendarDate = LocalTime.CalendarDate.fromDate(@date)

  toString: ->
    if value = @toTimeElapsedString()
      translate("elapsed", {value})
    else if date = @toWeekdayString()
      time = @toTimeString()
      translate("dateAtTime", {date, time})
    else
      translate("on", value: @toDateString())

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
      value = translate("second")
      translate("singular", {value})
    else if seconds < 45
      "#{seconds} #{translate("seconds")}"
    else if seconds < 90
      value = translate("minute")
      translate("singular", {value})
    else if minutes < 45
      "#{minutes} #{translate("minutes")}"
    else if minutes < 90
      value = translate("hour")
      translate("singularAn", {value})
    else if hours < 24
      "#{hours} #{translate("hours")}"
    else
      ""

  toWeekdayString: ->
    switch @calendarDate.daysPassed()
      when 0
        translate("today")
      when 1
        translate("yesterday")
      when -1
        translate("tomorrow")
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
