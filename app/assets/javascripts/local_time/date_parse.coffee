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
