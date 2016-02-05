browserIsCompatible = ->
  document.querySelectorAll and document.addEventListener

return unless browserIsCompatible()

i18n =
  weekdays: "Sunday Monday Tuesday Wednesday Thursday Friday Saturday"
  months: "January February March April May June July August September October November December"
  timeFormatWeekday: "$1 at $2"
  timeFormatAgo: "$1 ago"
  timeFormatOn: "on $1"
  dateFormatThisYear: "%b %e"
  dateFormatDefault: "%b %e, %Y"
  timeFormatDefault: "%l:%M%P"
  datetimeFormatDefault: "%B %e, %Y at %l:%M%P %Z"
  relativeTimeAgoSec: "a second"
  relativeTimeAgoSecs: "$1 seconds"
  relativeTimeAgoMin: "a minute"
  relativeTimeAgoMins: "$1 minutes"
  relativeTimeAgoHour: "an hour"
  relativeTimeAgoHours: "$1 hours"
  relativeTimeWeekdaysToday: "today"
  relativeTimeWeekdaysYesterday: "yesterday"
  relativeTimeWeekdaysTomorrow: "tomorrow"

t = () ->
  args = Array.prototype.slice.call(arguments);
  format = args.splice(0, 1)
  string = LocalTime.i18n[format]
  for value, index in args
    matcher = "$#{index + 1}"
    string = string.replace("$#{index + 1}", value)
  string

# Older browsers do not support ISO8601 (JSON) timestamps in Date.parse
if isNaN Date.parse "2011-01-01T12:00:00-05:00"
  parse = Date.parse
  iso8601 = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(Z|[-+]?[\d:]+)$/

  Date.parse = (dateString) ->
    dateString = dateString.toString()
    if matches = dateString.match iso8601
      [_, year, month, day, hour, minute, second, zone] = matches
      offset = zone.replace(":", "") if zone isnt "Z"
      dateString = "#{year}/#{month}/#{day} #{hour}:#{minute}:#{second} GMT#{[offset]}"
    parse dateString

pad = (num) -> ('0' + num).slice -2

parseTimeZone = (time) ->
  string = time.toString()
  # Sun Aug 30 2015 10:22:57 GMT-0400 (NAME)
  if name = string.match(/\(([\w\s]+)\)$/)?[1]
    if /\s/.test(name)
      # Sun Aug 30 2015 10:22:57 GMT-0400 (Eastern Daylight Time)
      name.match(/\b(\w)/g).join("")
    else
      # Sun Aug 30 2015 10:22:57 GMT-0400 (EDT)
      name
  # Sun Aug 30 10:22:57 EDT 2015
  else if name = string.match(/(\w{3,4})\s\d{4}$/)?[1]
    name
  # "Sun Aug 30 10:22:57 UTC-0400 2015"
  else if name = string.match(/(UTC[\+\-]\d+)/)?[1]
    name
  else
    ""

strftime = (time, formatString) ->
  day    = time.getDay()
  date   = time.getDate()
  month  = time.getMonth()
  year   = time.getFullYear()
  hour   = time.getHours()
  minute = time.getMinutes()
  second = time.getSeconds()

  formatString.replace /%([%aAbBcdeHIlmMpPSwyYZ])/g, ([match, modifier]) ->
    switch modifier
      when '%' then '%'
      when 'a' then LocalTime.i18n.weekdays.split(" ")[day].slice 0, 3
      when 'A' then LocalTime.i18n.weekdays.split(" ")[day]
      when 'b' then LocalTime.i18n.months.split(" ")[month].slice 0, 3
      when 'B' then LocalTime.i18n.months.split(" ")[month]
      when 'c' then time.toString()
      when 'd' then pad date
      when 'e' then date
      when 'H' then pad hour
      when 'I' then pad strftime time, '%l'
      when 'l' then (if hour is 0 or hour is 12 then 12 else (hour + 12) % 12)
      when 'm' then pad month + 1
      when 'M' then pad minute
      when 'p' then (if hour > 11 then 'PM' else 'AM')
      when 'P' then (if hour > 11 then 'pm' else 'am')
      when 'S' then pad second
      when 'w' then day
      when 'y' then pad year % 100
      when 'Y' then year
      when 'Z' then parseTimeZone(time)


class CalendarDate
  @fromDate: (date) ->
    new this date.getFullYear(), date.getMonth() + 1, date.getDate()

  @today: ->
    @fromDate new Date

  constructor: (year, month, day) ->
    @date = new Date Date.UTC year, month - 1
    @date.setUTCDate day

    @year = @date.getUTCFullYear()
    @month = @date.getUTCMonth() + 1
    @day = @date.getUTCDate()
    @value = @date.getTime()

  equals: (calendarDate) ->
    calendarDate?.value is @value

  is: (calendarDate) ->
    @equals calendarDate

  isToday: ->
    @is @constructor.today()

  occursOnSameYearAs: (date) ->
    @year is date?.year

  occursThisYear: ->
    @occursOnSameYearAs @constructor.today()

  daysSince: (date) ->
    if date
      (@date - date.date) / (1000 * 60 * 60 * 24)

  daysPassed: ->
    @constructor.today().daysSince @


class RelativeTime
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

relativeDate = (date) ->
  new RelativeTime(date).formatDate()

relativeTimeAgo = (date) ->
  new RelativeTime(date).toString()

relativeTimeOrDate = (date) ->
  new RelativeTime(date).toTimeOrDateString()

relativeWeekday = (date) ->
  if day = new RelativeTime(date).relativeWeekday()
    day.charAt(0).toUpperCase() + day.substring(1)


domLoaded = false

update = (callback) ->
  callback() if domLoaded

  document.addEventListener "time:elapse", callback

  if Turbolinks?.supported
    document.addEventListener "page:update", callback
  else
    jQuery?(document).on "ajaxSuccess", (event, xhr) ->
      callback() if jQuery.trim xhr.responseText

process = (selector, callback) ->
  update ->
    for element in document.querySelectorAll selector
      callback element

document.addEventListener "DOMContentLoaded", ->
  domLoaded = true
  textProperty = if "textContent" of document.body then "textContent" else "innerText"

  process "time[data-local]:not([data-localized])", (element) ->
    datetime = element.getAttribute "datetime"
    format   = element.getAttribute "data-format"
    local    = element.getAttribute "data-local"

    time = new Date Date.parse datetime
    return if isNaN time

    unless element.hasAttribute("title")
      element.setAttribute "title", strftime(time, t('datetimeFormatDefault'))

    element[textProperty] =
      switch local
        when "date"
          element.setAttribute "data-localized", true
          relativeDate time
        when "time"
          element.setAttribute "data-localized", true
          strftime time, format
        when "time-ago"
          relativeTimeAgo time
        when "time-or-date"
          relativeTimeOrDate time
        when "weekday"
          relativeWeekday(time) ? ""
        when "weekday-or-date"
          relativeWeekday(time) ? relativeDate(time)

run = ->
  event = document.createEvent "Events"
  event.initEvent "time:elapse", true, true
  document.dispatchEvent event

setInterval run, 60 * 1000

# Public API
@LocalTime = {relativeDate, relativeTimeAgo, relativeTimeOrDate, relativeWeekday, run, strftime, i18n}
