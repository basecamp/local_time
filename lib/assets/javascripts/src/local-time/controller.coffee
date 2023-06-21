import LocalTime from "./local_time"
import "./relative_time"
import "./page_observer"

{parseDate, strftime, getI18nValue, config} = LocalTime

class LocalTime.Controller
  SELECTOR = "time[data-local]:not([data-localized])"

  constructor: ->
    @pageObserver = new LocalTime.PageObserver SELECTOR, @processElements

  start: ->
    unless @started
      @processElements()
      @startTimer()
      @pageObserver.start()
      @started = true

  startTimer: ->
    if interval = config.timerInterval
      @timer ?= setInterval(@processElements, interval)

  processElements: (elements = document.querySelectorAll(SELECTOR)) =>
    @processElement(element) for element in elements
    elements.length

  processElement: (element) ->
    datetime = element.getAttribute("datetime")
    local = element.getAttribute("data-local")
    format = if config.useFormat24
      element.getAttribute("data-format24") || element.getAttribute("data-format")
    else
      element.getAttribute("data-format")

    time = parseDate(datetime)
    return if isNaN time

    unless element.hasAttribute("title")
      title = strftime(time, getI18nValue("datetime.formats.default"))
      element.setAttribute("title", title)

    element.textContent = content =
      switch local
        when "time"
          markAsLocalized(element)
          strftime(time, format)
        when "date"
          markAsLocalized(element)
          relative(time).toDateString()
        when "time-ago"
          relative(time).toString()
        when "time-or-date"
          relative(time).toTimeOrDateString()
        when "weekday"
          relative(time).toWeekdayString()
        when "weekday-or-date"
          relative(time).toWeekdayString() or relative(time).toDateString()

    unless element.hasAttribute("aria-label")
      element.setAttribute("aria-label", content)

  markAsLocalized = (element) ->
    element.setAttribute("data-localized", "")

  relative = (time) ->
    new LocalTime.RelativeTime time
