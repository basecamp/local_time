#= require ./calendar_date
#= require ./strftime
#= require ./i18n

{CalendarDate, strftime, i18n, t} = LocalTime

class LocalTime.RelativeTime
  constructor: (@date) ->
    @calendarDate = CalendarDate.fromDate @date

  toString: ->
    # Today: "Saved 5 hours ago"
    if ago = @timeElapsed()
      t('timeFormatAgo', ago)

    # Yesterday: "Saved yesterday at 8:15am"
    # This week: "Saved Thursday at 8:15am"
    else if day = @relativeWeekday()
      t('timeFormatWeekday', day, @formatTime())

    # Older: "Saved on Dec 15"
    else
      t('timeFormatOn', @formatDate())

  toTimeOrDateString: ->
    if @calendarDate.isToday()
      @formatTime()
    else
      @formatDate()

  timeElapsed: ->
    ms  = new Date().getTime() - @date.getTime()
    sec = Math.round ms  / 1000
    min = Math.round sec / 60
    hr  = Math.round min / 60

    if ms < 0
      null
    else if sec < 10
      t('relativeTimeAgoSec')
    else if sec < 45
      t('relativeTimeAgoSecs', sec)
    else if sec < 90
      t('relativeTimeAgoMin')
    else if min < 45
      t('relativeTimeAgoMins', min)
    else if min < 90
      t('relativeTimeAgoHour')
    else if hr < 24
      t('relativeTimeAgoHours', hr)
    else
      null

  relativeWeekday: ->
    switch @calendarDate.daysPassed()
      when 0
        t('relativeTimeWeekdaysToday')
      when 1
        t('relativeTimeWeekdaysYesterday')
      when -1
        t('relativeTimeWeekdaysTomorrow')
      when 2,3,4,5,6
        strftime @date, "%A"

  formatDate: ->
    if @calendarDate.occursThisYear()
      format = t('dateFormatThisYear')
    else
      format = t('dateFormatDefault')
    strftime @date, format

  formatTime: ->
    strftime @date, t('timeFormatDefault')
