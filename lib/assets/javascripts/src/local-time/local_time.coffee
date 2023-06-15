LocalTime =
  config: {}

  run: ->
    @getController().processElements()

  process: (elements...) ->
    for element in elements
      @getController().processElement(element)
    elements.length

  getController: ->
    @controller ?= new LocalTime.Controller

export default LocalTime
