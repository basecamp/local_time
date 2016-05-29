{elementMatchesSelector} = LocalTime

class LocalTime.PageObserver
  constructor: (@selector, @callback) ->

  start: ->
    unless @started
      @observeWithMutationObserver() or @observeWithMutationEvent()
      @started = true

  observeWithMutationObserver: ->
    if MutationObserver?
      observer = new MutationObserver @processMutations
      observer.observe(document.documentElement, childList: true, subtree: true)
      true

  observeWithMutationEvent: ->
    addEventListener("DOMNodeInserted", @processInsertion, false)
    true

  findSignificantElements: (element) ->
    elements = []
    if element?.nodeType is Node.ELEMENT_NODE
      elements.push(element) if elementMatchesSelector(element, @selector)
      elements.concat(element.querySelectorAll(@selector)...)
    elements

  processMutations: (mutations) =>
    elements = []
    for mutation in mutations
      switch mutation.type
        when "childList"
          for node in mutation.addedNodes
            elements.push(@findSignificantElements(node)...)
    @notify(elements)

  processInsertion: (event) =>
    elements = @findSignificantElements(event.target)
    @notify(elements)

  notify: (elements) ->
    if elements?.length
      @callback?(elements)
