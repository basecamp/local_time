#= require ./relative_time
#= require ./strftime

{RelativeTime, strftime, t} = LocalTime

class LocalTime.Controller
  @selector: "time[data-local]:not([data-localized])"
  @interval: 60 * 1000

  start: ->
    unless @started
      addEventListener("DOMContentLoaded", @pageUpdated, false)
      setInterval(@processElements, @constructor.interval)

      if Turbolinks?.supported
        document.addEventListener("page:update", @pageUpdated, false)
      else if jQuery?
        jQuery(document).on "ajaxSuccess", (event, xhr) =>
          if jQuery.trim xhr.responseText
            @pageUpdated()

      @started = true

  pageUpdated: (event) =>
    @processElements()

  processElements: ->
    elements = document.querySelectorAll(@constructor.selector)
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

do ->
  LocalTime.controller = controller = new LocalTime.Controller
  controller.start()
