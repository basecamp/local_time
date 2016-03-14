LocalTime.i18n = i18n =
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

LocalTime.t = ->
  args = Array.prototype.slice.call(arguments);
  format = args.splice(0, 1)
  string = i18n[format]
  for value, index in args
    matcher = "$#{index + 1}"
    string = string.replace("$#{index + 1}", value)
  string
