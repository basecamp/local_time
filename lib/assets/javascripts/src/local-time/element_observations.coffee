import LocalTime from "./local_time"

{elementMatchesSelector} = LocalTime

class LocalTime.ElementObservations
  OBSERVABLE_ATTRIBUTES = [ "datetime", "data-local", "data-format", "data-format24" ]

  constructor: (@selector, @callback) ->
    @observedElements = new Map()

  observe: (element) =>
    unless element.hasAttribute("data-observed")
      observer = @startObserving(element)
      @registerObserver(element, observer)
      markAsObserved(element)

  disregard: (element) =>
    if observer = @observedElements.get(element)?.observer
      observer.disconnect()
      @observedElements.delete(element)

  startObserving: (element) =>
    observer = new MutationObserver(@processMutations)
    observer.observe(element, characterData: true, subtree: true, attributes: true, attributeFilter: OBSERVABLE_ATTRIBUTES)
    observer

  registerObserver: (element, observer) =>
    @observedElements.set(element, { observer: observer, updates: -1 })
    @incrementUpdates(element)

  processMutations: (mutations) =>
    for mutation in mutations
      target = mutation.target

      element = if target.nodeType is Node.TEXT_NODE
        target.parentNode
      else
        target

      if elementMatchesSelector(element, @selector)
        @processLingeringElement(element)
        break

  processLingeringElement: (element) =>
    markAsObserved(element)
    @incrementUpdates(element)
    @callback(element)

  incrementUpdates: (element) =>
    @observedElements.get(element).updates++
    element.setAttribute("data-updates", @observedElements.get(element).updates)

  size: ->
    @observedElements.size

  markAsObserved = (element) ->
    element.setAttribute("data-observed", "")
