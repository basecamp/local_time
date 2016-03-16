#= require ./calendar_date

{CalendarDate, strftime, translate, getI18nValue} = LocalTime

class LocalTime.RelativeTime
  constructor: (@date) ->
    @calendarDate = CalendarDate.fromDate @date

  toString: ->
    if value = @timeElapsed()
      translate("elapsed", {value})
    else if date = @relativeWeekday()
      time = @formatTime()
      translate("dateAtTime", {date, time})
    else
      translate("on", value: @formatDate())

  toTimeOrDateString: ->
    if @calendarDate.isToday()
      @formatTime()
    else
      @formatDate()

  timeElapsed: ->
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
      null

  relativeWeekday: ->
    switch @calendarDate.daysPassed()
      when 0
        translate("today")
      when 1
        translate("yesterday")
      when -1
        translate("tomorrow")
      when 2,3,4,5,6
        strftime(@date, "%A")

  formatDate: ->
    format = if @calendarDate.occursThisYear()
      getI18nValue("date.formats.thisYear")
    else
      getI18nValue("date.formats.default")

    strftime(@date, format)

  formatTime: ->
    strftime(@date, getI18nValue("time.formats.default"))
