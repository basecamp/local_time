class LocalTime.PageObserver
  constructor: (@delegate) ->

  start: ->
    unless @started
      @observeWithMutationObserver() or @observeWithJQuery()
      @started = true

  observeWithMutationObserver: ->
    if MutationObserver?
      observer = new MutationObserver @notify
      observer.observe(document.body, childList: true)
      true

  observeWithJQuery: ->
    if jQuery?
      jQuery(document).on "ajaxSuccess", (event, xhr) =>
        if jQuery.trim xhr.responseText
          @notify()
      true

  notify: =>
    @delegate.pageUpdated?()
