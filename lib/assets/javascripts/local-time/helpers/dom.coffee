  LocalTime.elementMatchesSelector = do ->
    element = document.documentElement
    method = element.matches ?
      element.matchesSelector ?
      element.webkitMatchesSelector ?
      element.mozMatchesSelector ?
      element.msMatchesSelector

    (element, selector) ->
      if element?.nodeType is Node.ELEMENT_NODE
        method.call(element, selector)
