import LocalTime from "./local_time"
import "./relative_time"
import "./page_observer"

const { parseDate, strftime, getI18nValue, config } = LocalTime

const SELECTOR = "time[data-local]:not([data-localized])"
const markAsLocalized = element => element.setAttribute("data-localized", "")
const markAsProcessed = element => element.setAttribute("data-processed-at", new Date().toISOString())
const relative = (time, options) => new LocalTime.RelativeTime(time, options)

LocalTime.Controller = class Controller {
  constructor() {
    this.processElements = this.processElements.bind(this)
    this.pageObserver = new LocalTime.PageObserver(SELECTOR, this.processElements)
  }

  start() {
    if (!this.started) {
      this.processElements()
      this.startTimer()
      this.pageObserver.start()
      this.started = true
    }
  }

  startTimer() {
    let interval
    if (interval = config.timerInterval) {
      if (!this.timer) this.timer = setInterval(this.processElements, interval)
    }
  }

  processElements(elements) {
    if (!elements) elements = document.querySelectorAll(SELECTOR)
    for (const element of Array.from(elements)) this.processElement(element)
    return elements.length
  }

  processElement(element) {
    const datetime = element.getAttribute("datetime")
    const local = element.getAttribute("data-local")
    const format = config.useFormat24
      ? element.getAttribute("data-format24") || element.getAttribute("data-format")
      : element.getAttribute("data-format")

    const time = parseDate(datetime)
    if (isNaN(time)) return

    if (!element.hasAttribute("title")) {
      const title_format = config.useFormat24 ? "default_24h" : "default"
      const title = strftime(time, getI18nValue(`datetime.formats.${title_format}`))
      element.setAttribute("title", title)
    }

    markAsProcessed(element)

    element.textContent = (() => {
      switch (local) {
        case "time":
          markAsLocalized(element)
          return strftime(time, format)
        case "date":
          markAsLocalized(element)
          return relative(time).toDateString()
        case "relative": case "time-ago":
          return relative(time, element.dataset).toString()
        case "time-or-date":
          return relative(time).toTimeOrDateString()
        case "weekday":
          return relative(time).toWeekdayString()
        case "weekday-or-date":
          return relative(time).toWeekdayString() || relative(time).toDateString()
      }
    })()
  }
}
