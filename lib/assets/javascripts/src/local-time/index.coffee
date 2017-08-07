#= export LocalTime
#= require_self
#= require_tree ./config
#= require_tree ./helpers
#= require ./controller
#= require ./start

@LocalTime =
  config: {}

  run: ->
    @getController().processElements()

  process: (elements...) ->
    for element in elements
      @getController().processElement(element)
    elements.length

  getController: ->
    @controller ?= new LocalTime.Controller
