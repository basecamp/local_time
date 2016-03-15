#= require ./page_observer
#= require ./relative_time
#= require ./strftime

{RelativeTime, strftime, t} = LocalTime

class LocalTime.Controller
  @interval: 60 * 1000

  constructor: ->
    @pageObserver = new LocalTime.PageObserver this
    addEventListener("DOMContentLoaded", @pageLoaded, false)

  pageLoaded: =>
    @processElements()
    setInterval(@processElements, @constructor.interval)
    @pageObserver.start()

  pageUpdateObserved: ->
    @processElements()

  processElements: =>
    elements = document.querySelectorAll("time[data-local]:not([data-localized])")
    @processElement(element) for element in elements
    elements.length

  processElement: (element) ->
    datetime = element.getAttribute "datetime"
    format   = element.getAttribute "data-format"
    local    = element.getAttribute "data-local"

    time = new Date Date.parse datetime
    return if isNaN time

    unless element.hasAttribute("title")
      element.setAttribute "title", strftime(time, t('datetimeFormatDefault'))

    element.textContent =
      switch local
        when "date"
          element.setAttribute "data-localized", true
          relativeDate time
        when "time"
          element.setAttribute "data-localized", true
          strftime time, format
        when "time-ago"
          relativeTimeAgo time
        when "time-or-date"
          relativeTimeOrDate time
        when "weekday"
          relativeWeekday(time) ? ""
        when "weekday-or-date"
          relativeWeekday(time) ? relativeDate(time)

  relativeDate = (date) ->
    new RelativeTime(date).formatDate()

  relativeTimeAgo = (date) ->
    new RelativeTime(date).toString()

  relativeTimeOrDate = (date) ->
    new RelativeTime(date).toTimeOrDateString()

  relativeWeekday = (date) ->
    if day = new RelativeTime(date).relativeWeekday()
      day.charAt(0).toUpperCase() + day.substring(1)

LocalTime.controller = new LocalTime.Controller
