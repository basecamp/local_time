# Older browsers do not support ISO8601 (JSON) timestamps in Date.parse
supportsISO8601 = not isNaN Date.parse("2011-01-01T12:00:00-05:00")

LocalTime.parseDate = (dateString) ->
  dateString = dateString.toString()
  dateString = reformatDateString(dateString) unless supportsISO8601
  new Date Date.parse(dateString)

iso8601Pattern = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(Z|[-+]?[\d:]+)$/

reformatDateString = (dateString) ->
  if matches = dateString.match(iso8601Pattern)
    [_, year, month, day, hour, minute, second, zone] = matches
    offset = zone.replace(":", "") if zone isnt "Z"
    "#{year}/#{month}/#{day} #{hour}:#{minute}:#{second} GMT#{[offset]}"
