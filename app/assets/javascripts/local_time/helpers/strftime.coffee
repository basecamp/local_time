{getI18nValue} = LocalTime

LocalTime.strftime = strftime = (time, formatString) ->
  day    = time.getDay()
  date   = time.getDate()
  month  = time.getMonth()
  year   = time.getFullYear()
  hour   = time.getHours()
  minute = time.getMinutes()
  second = time.getSeconds()

  formatString.replace /%([%aAbBcdeHIlmMpPSwyYZ])/g, ([match, modifier]) ->
    switch modifier
      when "%" then "%"
      when "a" then getI18nValue("date.dayNames")[day].slice(0, 3)
      when "A" then getI18nValue("date.dayNames")[day]
      when "b" then getI18nValue("date.monthNames")[month].slice(0, 3)
      when "B" then getI18nValue("date.monthNames")[month]
      when "c" then time.toString()
      when "d" then pad(date)
      when "e" then date
      when "H" then pad(hour)
      when "I" then pad(strftime(time, "%l"))
      when "l" then (if hour is 0 or hour is 12 then 12 else (hour + 12) % 12)
      when "m" then pad(month + 1)
      when "M" then pad(minute)
      when "p" then (if hour > 11 then "PM" else "AM")
      when "P" then (if hour > 11 then "pm" else "am")
      when "S" then pad(second)
      when "w" then day
      when "y" then pad(year % 100)
      when "Y" then year
      when "Z" then parseTimeZone(time)

pad = (num) ->
  ("0#{num}").slice(-2)

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
