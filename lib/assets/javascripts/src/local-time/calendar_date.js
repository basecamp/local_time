import LocalTime from "./local_time"

LocalTime.CalendarDate = class CalendarDate {
  static fromDate(date) {
    return new (this)(date.getFullYear(), date.getMonth() + 1, date.getDate())
  }

  static today() {
    return this.fromDate(new Date)
  }

  constructor(year, month, day) {
    this.date = new Date(Date.UTC(year, month - 1))
    this.date.setUTCDate(day)

    this.year = this.date.getUTCFullYear()
    this.month = this.date.getUTCMonth() + 1
    this.day = this.date.getUTCDate()
    this.value = this.date.getTime()
  }

  equals(calendarDate) {
    return calendarDate?.value === this.value
  }

  is(calendarDate) {
    return this.equals(calendarDate)
  }

  isToday() {
    return this.is(this.constructor.today())
  }

  occursOnSameYearAs(date) {
    return this.year === date?.year
  }

  occursThisYear() {
    return this.occursOnSameYearAs(this.constructor.today())
  }

  daysSince(date) {
    if (date) {
      return (this.date - date.date) / (1000 * 60 * 60 * 24)
    }
  }

  daysPassed() {
    return this.constructor.today().daysSince(this)
  }
}
