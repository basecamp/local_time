import LocalTime from "./local_time"
import "./calendar_date"

const { strftime, translate, getI18nValue, config } = LocalTime

LocalTime.RelativeTime = class RelativeTime {
  constructor(date) {
    this.date = date
    this.calendarDate = LocalTime.CalendarDate.fromDate(this.date)
  }

  toString() {
    let date, time
    if (time = this.toTimeElapsedString()) {
      return translate("time.elapsed", { time })
    } else if (date = this.toWeekdayString()) {
      time = this.toTimeString()
      return translate("datetime.at", { date, time })
    } else {
      return translate("date.on", { date: this.toDateString() })
    }
  }

  toTimeOrDateString() {
    if (this.calendarDate.isToday()) {
      return this.toTimeString()
    } else {
      return this.toDateString()
    }
  }

  toTimeElapsedString() {
    let time
    const ms = new Date().getTime() - this.date.getTime()
    const seconds = Math.round(ms / 1000)
    const minutes = Math.round(seconds / 60)
    const hours = Math.round(minutes / 60)

    if (ms < 0) {
      return null
    } else if (seconds < 10) {
      time = translate("time.second")
      return translate("time.singular", { time })
    } else if (seconds < 45) {
      return `${seconds} ${translate("time.seconds")}`
    } else if (seconds < 90) {
      time = translate("time.minute")
      return translate("time.singular", { time })
    } else if (minutes < 45) {
      return `${minutes} ${translate("time.minutes")}`
    } else if (minutes < 90) {
      time = translate("time.hour")
      return translate("time.singularAn", { time })
    } else if (hours < 24) {
      return `${hours} ${translate("time.hours")}`
    } else {
      return ""
    }
  }

  toWeekdayString() {
    switch (this.calendarDate.daysPassed()) {
      case 0:
        return translate("date.today")
      case 1:
        return translate("date.yesterday")
      case -1:
        return translate("date.tomorrow")
      case 2: case 3: case 4: case 5: case 6:
        return strftime(this.date, "%A")
      default:
        return ""
    }
  }

  toDateString() {
    const format = this.calendarDate.occursThisYear()
      ? getI18nValue("date.formats.thisYear")
      : getI18nValue("date.formats.default")

    return strftime(this.date, format)
  }

  toTimeString() {
    const format = config.useFormat24 ? "default_24h" : "default"
    return strftime(this.date, getI18nValue(`time.formats.${format}`))
  }
}
