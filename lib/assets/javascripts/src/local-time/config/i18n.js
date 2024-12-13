import LocalTime from "../local_time"

LocalTime.config.i18n =
  en:
    date:
      dayNames: [
        "Sunday"
        "Monday"
        "Tuesday"
        "Wednesday"
        "Thursday"
        "Friday"
        "Saturday"
      ]
      abbrDayNames: [
        "Sun"
        "Mon"
        "Tue"
        "Wed"
        "Thu"
        "Fri"
        "Sat"
      ]
      monthNames: [
        "January"
        "February"
        "March"
        "April"
        "May"
        "June"
        "July"
        "August"
        "September"
        "October"
        "November"
        "December"
      ]
      abbrMonthNames: [
        "Jan"
        "Feb"
        "Mar"
        "Apr"
        "May"
        "Jun"
        "Jul"
        "Aug"
        "Sep"
        "Oct"
        "Nov"
        "Dec"
      ]
      yesterday: "yesterday"
      today: "today"
      tomorrow: "tomorrow"
      on: "on {date}"
      formats:
        default: "%b %e, %Y"
        thisYear: "%b %e"
    time:
      am: "am"
      pm: "pm"
      singular: "a {time}"
      singularAn: "an {time}"
      elapsed: "{time} ago"
      second: "second"
      seconds: "seconds"
      minute: "minute"
      minutes: "minutes"
      hour: "hour"
      hours: "hours"
      formats:
        default: "%l:%M%P"
        default_24h: "%H:%M"
    datetime:
      at: "{date} at {time}"
      formats:
        default: "%B %e, %Y at %l:%M%P %Z"
        default_24h: "%B %e, %Y at %H:%M %Z"
