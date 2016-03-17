class LocalTime.PageObserver
  constructor: (@delegate) ->

  start: ->
    unless @started
      @observeWithMutationObserver() or @observeWithMutationEvent()
      @started = true

  observeWithMutationObserver: ->
    if MutationObserver?
      observer = new MutationObserver @notify
      observer.observe(document.body, childList: true)
      true

  observeWithMutationEvent: ->
    addEventListener("DOMNodeInserted", @notify, false)
    true

  notify: =>
    @delegate.pageUpdateObserved?()
