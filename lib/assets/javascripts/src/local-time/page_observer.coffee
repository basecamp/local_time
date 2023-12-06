import LocalTime from "./local_time"

{elementMatchesSelector} = LocalTime

class LocalTime.PageObserver
  constructor: ({
    elementAddedSelector,
    elementAddedCallback,
    elementRemovedSelector,
    elementRemovedCallback
  }) ->
    @elementAddedSelector = elementAddedSelector
    @elementAddedCallback = elementAddedCallback
    @elementRemovedSelector = elementRemovedSelector
    @elementRemovedCallback = elementRemovedCallback

  start: ->
    unless @started
      @observe()
      @started = true

  observe: ->
    observer = new MutationObserver @processMutations
    observer.observe(document.documentElement, childList: true, subtree: true)

  processMutations: (mutations) =>
    elements = []

    for mutation in mutations
      switch mutation.type
        when "childList"
          for node in mutation.addedNodes
            elements.push(@findSignificantElements(node)...)

          for node in mutation.removedNodes
            if elementMatchesSelector(node, @elementRemovedSelector)
              @elementRemovedCallback(node)

    @notify(elements)

  findSignificantElements: (element) ->
    elements = []
    if element?.nodeType is Node.ELEMENT_NODE
      elements.push(element) if elementMatchesSelector(element, @elementAddedSelector)
      elements.push(element.querySelectorAll(@elementAddedSelector)...)
    elements

  processInsertion: (event) =>
    elements = @findSignificantElements(event.target)
    @notify(elements)

  notify: (elements) ->
    if elements?.length
      @elementAddedCallback?(elements)
