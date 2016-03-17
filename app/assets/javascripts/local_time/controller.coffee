#= require ./relative_time
#= require ./page_observer

{parseDate, strftime, getI18nValue} = LocalTime

class LocalTime.Controller
  @interval: 60 * 1000

  constructor: ->
    @pageObserver = new LocalTime.PageObserver this

  start: ->
    unless @started
      @processElements()
      setInterval(@processElements, @constructor.interval)
      @pageObserver.start()
      @started = true

  pageUpdateObserved: ->
    @processElements()

  processElements: =>
    elements = document.querySelectorAll("time[data-local]:not([data-localized])")
    @processElement(element) for element in elements
    elements.length

  processElement: (element) ->
    datetime = element.getAttribute("datetime")
    format = element.getAttribute("data-format")
    local = element.getAttribute("data-local")

    time = parseDate(datetime)
    return if isNaN time

    unless element.hasAttribute("title")
      title = strftime(time, getI18nValue("datetime.formats.default"))
      element.setAttribute("title", title)

    element.textContent = switch local
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

  markAsLocalized = (element) ->
    element.setAttribute("data-localized", "")

  relative = (time) ->
    new LocalTime.RelativeTime time
