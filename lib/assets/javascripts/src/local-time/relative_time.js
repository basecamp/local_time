import LocalTime from "./local_time"
import "./calendar_date"

const { strftime, translate, getI18nValue, config } = LocalTime

LocalTime.RelativeTime = class RelativeTime {
  constructor(date, options = {}) {
    this.date = date
    this.calendarDate = LocalTime.CalendarDate.fromDate(this.date)
    this.pastPrefix = options.pastPrefix
    this.futurePrefix = options.futurePrefix
  }

  toString() {
    return `${this.#tensePrefix} ${this.#relativeTimeString}`.replace(/^\s+/, "")
  }

  toTimeOrDateString() {
    if (this.calendarDate.isToday()) {
      return this.#toTimeString
    } else {
      return this.toDateString()
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
        return this.#weekday
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

  get #tensePrefix() {
    return (this.#isFuture ? this.futurePrefix : this.pastPrefix) || ""
  }

  get #isFuture() {
    return !this.#isPast
  }

  get #isPast() {
    return this.#signedMilliseconds > 0
  }

  get #signedMilliseconds() {
    return new Date().getTime() - this.date.getTime()
  }

  get #relativeTimeString() {
    if (this.#seconds < 2) {
      return this.#tenseAwareTranslate("second")
    } else if (this.#seconds < 60) {
      return this.#tenseAwareTranslate("seconds", { value: this.#seconds })
    } else if (this.#seconds < 90) {
      return this.#tenseAwareTranslate("minute")
    } else if (this.#minutes < 45) {
      return this.#tenseAwareTranslate("minutes", { value: this.#minutes })
    } else if (this.#minutes < 90) {
      return this.#tenseAwareTranslate("hour")
    } else if (this.#hours < 24) {
      return this.#tenseAwareTranslate("hours", { value: this.#hours })
    } else if (this.#days < 2) {
      return this.#tenseAwareTranslate("nextDay", { time: this.#toTimeString })
    } else if (this.#days < 7) {
      return this.#tenseAwareTranslate("weekday", { weekday: this.#weekday, time: this.#toTimeString })
    } else {
      return this.#tenseAwareTranslate("date", { date: this.toDateString() } )
    }
  }

  #tenseAwareTranslate(key, interpolations) {
    return translate(`time.${this.#tense}.${key}`, interpolations)
  }

  get #tense() {
    return this.#isPast ? "past" : "future"
  }

  get #toTimeString() {
    const format = config.useFormat24 ? "default_24h" : "default"
    return strftime(this.date, getI18nValue(`time.formats.${format}`))
  }

  get #weekday() {
    return strftime(this.date, "%A")
  }

  get #days() {
    return Math.round(this.#hours / 24)
  }

  get #hours() {
    return Math.round(this.#minutes / 60)
  }

  get #minutes() {
    return Math.round(this.#seconds / 60)
  }

  get #seconds() {
    return Math.round(this.#milliseconds / 1000)
  }

  get #milliseconds() {
    return Math.abs(this.#signedMilliseconds)
  }
}
