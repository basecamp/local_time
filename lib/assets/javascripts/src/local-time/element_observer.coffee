import LocalTime from "./local_time"

{elementMatchesSelector} = LocalTime

class LocalTime.ElementObserver
  constructor: (@selector, @callback) ->

  start: ->
    unless @started
      @observeWithMutationObserver()
      @started = true

  observeWithMutationObserver: ->
    observer = new MutationObserver @processMutations
    observer.observe(document.documentElement, childList: true, subtree: true)

  processMutations: (mutations) =>
    for mutation in mutations
      switch mutation.type
        when "childList"
          for removedNode in mutation.removedNodes
            if elementMatchesSelector(removedNode, @selector)
              @callback(removedNode)
