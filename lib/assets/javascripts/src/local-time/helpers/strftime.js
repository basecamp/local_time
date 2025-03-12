import LocalTime from "../local_time"

const { getI18nValue, translate } = LocalTime

const supportsIntlDateFormat = typeof (Intl?.DateTimeFormat) === "function"

const knownEdgeCaseTimeZones = {
  "Central European Standard Time": "CET",
  "Central European Summer Time": "CEST",
  "China Standard Time": "CST",
  "Israel Daylight Time": "IDT",
  "Israel Standard Time": "IST",
  "Moscow Standard Time": "MSK",
  "Peru Standard Time": "PET",
  "Philippine Standard Time": "PHT",
  "Singapore Standard Time": "SGT",
  "Western Indonesia Time": "WIB"
}

LocalTime.knownEdgeCaseTimeZones = knownEdgeCaseTimeZones

LocalTime.strftime = (() => {
  const strftime = (time, formatString) => {
    const day = time.getDay()
    const date = time.getDate()
    const month = time.getMonth()
    const year = time.getFullYear()
    const hour = time.getHours()
    const minute = time.getMinutes()
    const second = time.getSeconds()

    return formatString.replace(/%(-?)([%aAbBcdeHIlmMpPSwyYZ])/g, (match, flag, modifier) => {
      switch (modifier) {
        case "%": return "%"
        case "a": return getI18nValue("date.abbrDayNames")[day]
        case "A": return getI18nValue("date.dayNames")[day]
        case "b": return getI18nValue("date.abbrMonthNames")[month]
        case "B": return getI18nValue("date.monthNames")[month]
        case "c": return time.toString()
        case "d": return pad(date, flag)
        case "e": return date
        case "H": return pad(hour, flag)
        case "I": return pad(strftime(time, "%l"), flag)
        case "l": return (hour === 0 || hour === 12) ? 12 : ((hour + 12) % 12)
        case "m": return pad(month + 1, flag)
        case "M": return pad(minute, flag)
        case "p": return translate(`time.${(hour > 11 ? "pm" : "am")}`).toUpperCase()
        case "P": return translate(`time.${(hour > 11 ? "pm" : "am")}`)
        case "S": return pad(second, flag)
        case "w": return day
        case "y": return pad(year % 100, flag)
        case "Y": return year
        case "Z": return shortTimeZone(time)
      }
    })
  }

  function pad(num, flag) {
    switch (flag) {
      case "-": return num
      default: return (`0${num}`).slice(-2)
    }
  }

  function shortTimeZone(time) {
    let gmtOffset, longTimeZoneName, shortTimeZoneName
    if (longTimeZoneName = edgeCaseTimeZoneNameFor(time)) {
      return knownEdgeCaseTimeZones[longTimeZoneName]
    } else if (shortTimeZoneName = shortTimeZoneNameFromIntl(time, { allowGMT: false })) {
      return shortTimeZoneName
    } else if (shortTimeZoneName = shortTimeZoneNameFromHeuristic(time)) {
      return shortTimeZoneName
    } else if (gmtOffset = shortTimeZoneNameFromIntl(time, { allowGMT: true })) {
      return gmtOffset
    } else {
      return ""
    }
  }

  function edgeCaseTimeZoneNameFor(time) {
    return Object.keys(knownEdgeCaseTimeZones).find((name) => {
      if (supportsIntlDateFormat) {
        return new Date(time).toLocaleString("en-US", { timeZoneName: "long" }).includes(name)
      } else {
        return time.toString().includes(name)
      }
    })
  }

  function shortTimeZoneNameFromIntl(time, { allowGMT }) {
    if (supportsIntlDateFormat) {
      const shortTimeZoneName = new Date(time).toLocaleString("en-US", { timeZoneName: "short" }).split(" ").pop()
      if (allowGMT || !shortTimeZoneName.includes("GMT")) return shortTimeZoneName
    }
  }

  function shortTimeZoneNameFromHeuristic(time) {
    const string = time.toString()
    // Sun Aug 30 2015 10:22:57 GMT-0400 (NAME)
    let match
    if ((match = string.match(/\(([\w\s]+)\)$/)) != null) {
      const name = match[ 1 ]
      if (/\s/.test(name)) {
        // Sun Aug 30 2015 10:22:57 GMT-0400 (Eastern Daylight Time)
        return name.match(/\b(\w)/g).join("")
      } else {
        // Sun Aug 30 2015 10:22:57 GMT-0400 (EDT)
        return name
      }
    } else if ((match = string.match(/(\w{3,4})\s\d{4}$/)) != null) {
      // Sun Aug 30 10:22:57 EDT 2015
      return match[ 1 ]
    } else if ((match = string.match(/(UTC[\+\-]\d+)/)) != null) {
      // "Sun Aug 30 10:22:57 UTC-0400 2015"
      return match[ 1 ]
    }
  }

  return strftime
})()
