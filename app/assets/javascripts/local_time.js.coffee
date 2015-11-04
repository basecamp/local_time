browserIsCompatible = ->
  document.querySelectorAll and document.addEventListener

return unless browserIsCompatible()

# Merge & tap functions from GIST: https://gist.github.com/sheldonh/6089299 
merge = (xs...) ->
  if xs?.length > 0
    tap {}, (m) -> m[k] = v for k, v of x for x in xs
tap = (o, fn) -> fn(o); o

if not window.local_time?
  window.local_time = {}

# default value for strings (english)
_local_time_i18n = 
  weekdays: "Sunday Monday Tuesday Wednesday Thursday Friday Saturday"
  months: 'January February March April May June July August September Obtober November December'
  time_format_weekday: "%{str_day} at %{formatted_time}"
  time_format_ago: "%{relative_time} ago"
  time_format_on: "on %{formatted_date}"
  date_format_this_year: "%b %e"
  date_format_default: "%b %e, %Y"
  time_format_default: "%l:%M%P"
  datetime_format_default: "%B %e, %Y at %l:%M%P %Z"
  relative_time_ago_sec: "a second"
  relative_time_ago_secs: "%{secs} seconds"
  relative_time_ago_min: "a minute"
  relative_time_ago_mins: "%{mins} minutes"
  relative_time_ago_hour: "an hour"
  relative_time_ago_hours: "%{hours} hours"
  relative_time_weekdays_today: "today"
  relative_time_weekdays_yesterday: "yesterday"
  relative_time_weekdays_tomorrow: "tomorrow"
  
local_time.i18n = merge _local_time_i18n, window.local_time.i18n


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
  
weekdays = local_time.i18n.weekdays.split " "
months   = local_time.i18n.months.split " "

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
      when 'a' then weekdays[day].slice 0, 3
      when 'A' then weekdays[day]
      when 'b' then months[month].slice 0, 3
      when 'B' then months[month]
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
      local_time.i18n.time_format_ago.replace(/%{relative_time}/g, ago)

    # Yesterday: "Saved yesterday at 8:15am"
    # This week: "Saved Thursday at 8:15am"
    else if day = @relativeWeekday()
      local_time.i18n.time_format_weekday.replace(/%{str_day}/g, day).replace(/%{formatted_time}/g, @formatTime())

    # Older: "Saved on Dec 15"
    else
      local_time.i18n.time_format_on.replace(/%{formatted_date}/g, @formatDate()).replace(/%{formatted_time}/g, @formatTime())

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
      local_time.i18n.relative_time_ago_sec
    else if sec < 45
      local_time.i18n.relative_time_ago_secs.replace(/%{secs}/g, sec)
    else if sec < 90
      local_time.i18n.relative_time_ago_min
    else if min < 45
      local_time.i18n.relative_time_ago_mins.replace(/%{mins}/g, min)
    else if min < 90
      local_time.i18n.relative_time_ago_hour
    else if hr < 24
      local_time.i18n.relative_time_ago_hours.replace(/%{hours}/g, hr)
    else
      null

  relativeWeekday: ->
    switch @calendarDate.daysPassed()
      when 0
        local_time.i18n.relative_time_weekdays_today
      when 1
        local_time.i18n.relative_time_weekdays_yesterday
      when -1
        local_time.i18n.relative_time_weekdays_tomorrow
      when 2,3,4,5,6
        strftime @date, "%A"

  formatDate: ->
    format = local_time.i18n.date_format_default
    format = local_time.i18n.date_format_this_year if @calendarDate.occursThisYear()
    strftime @date, format

  formatTime: ->
    strftime @date, local_time.i18n.time_format_default

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
      element.setAttribute "title", strftime(time, local_time.i18n.datetime_format_default)

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
@LocalTime = {relativeDate, relativeTimeAgo, relativeTimeOrDate, relativeWeekday, run, strftime}
