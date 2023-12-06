import LocalTime from "./local_time"

{elementMatchesSelector} = LocalTime

class LocalTime.ElementObservations
  OBSERVABLE_ATTRIBUTES = [ "datetime", "data-local", "data-format", "data-format24" ]

  constructor: (@selector, @callback) ->
    @elements = new Map()

  include: (element) =>
    unless element.hasAttribute("data-observed")
      observer = @startObserving(element)
      @registerObserver(element, observer)
      markAsObserved(element)

  disregard: (element) =>
    if observer = @elements.get(element)?.observer
      observer.disconnect()
      @elements.delete(element)

  startObserving: (element) =>
    observer = new MutationObserver(@processMutations)
    observer.observe(element, characterData: true, subtree: true, attributes: true, attributeFilter: OBSERVABLE_ATTRIBUTES)
    observer

  registerObserver: (element, observer) =>
    @elements.set(element, { observer: observer, updates: -1 })
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
    @elements.get(element).updates++
    element.setAttribute("data-updates", @elements.get(element).updates)

  size: ->
    @elements.size

  markAsObserved = (element) ->
    element.setAttribute("data-observed", "")
