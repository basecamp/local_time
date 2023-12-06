import LocalTime from "./local_time"
import "./relative_time"
import "./page_observer"

{parseDate, strftime, getI18nValue, config, elementMatchesSelector} = LocalTime

class LocalTime.Controller
  SELECTOR = "time[data-local]"
  NON_LOCALIZED_SELECTOR = "#{SELECTOR}:not([data-localized])"
  OBSERVER_OPTIONS =
    characterData: true
    subtree: true
    attributes: true
    attributeFilter: [ "datetime", "data-local", "data-format", "data-format24" ]

  constructor: ->
    @observedElements = new Map()
    @pageObserver = new LocalTime.PageObserver(
      elementAddedSelector: NON_LOCALIZED_SELECTOR,
      elementAddedCallback: @processElements,
      elementRemovedSelector: SELECTOR,
      elementRemovedCallback: @disconnectObserver
    )

  start: ->
    unless @started
      @processElements()
      @startTimer()
      @pageObserver.start()
      @started = true

  startTimer: ->
    if interval = config.timerInterval
      @timer ?= setInterval(@processElements, interval)

  processElements: (elements = document.querySelectorAll(NON_LOCALIZED_SELECTOR)) =>
    @processElement(element) for element in elements
    elements.length

  disconnectObserver: (element) =>
    if observer = @observedElements.get(element)?.observer
      observer.disconnect()
      @observedElements.delete(element)

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
      title_format = if config.useFormat24 then "default_24h" else "default"
      title = strftime(time, getI18nValue("datetime.formats.#{title_format}"))
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

    @observe(element)

  observe: (element) =>
    unless element.hasAttribute("data-observed")
      markAsObserved(element)
      observer = new MutationObserver(@processMutations)
      observer.observe(element, OBSERVER_OPTIONS)
      @observedElements.set(element, { observer: observer, updates: -1 })
      @incrementUpdates(element)

  processMutations: (mutations) =>
    for mutation in mutations
      target = mutation.target

      element = if target.nodeType is Node.TEXT_NODE
        target.parentNode
      else
        target

      if elementMatchesSelector(element, SELECTOR)
        @processLingeringElement(element)
        break

  processLingeringElement: (element) =>
    markAsObserved(element)
    @incrementUpdates(element)
    @processElement(element)

  incrementUpdates: (element) =>
    @observedElements.get(element).updates++
    element.setAttribute("data-updates", @observedElements.get(element).updates)

  markAsObserved = (element) ->
    element.setAttribute("data-observed", "")

  markAsLocalized = (element) ->
    element.setAttribute("data-localized", "")

  relative = (time) ->
    new LocalTime.RelativeTime time
