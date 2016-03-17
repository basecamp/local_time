#= require_self
#= require_tree ./config
#= require_tree ./helpers
#= require ./controller

@LocalTime =
  config: {}

  install: ->
    unless @installed
      if document.readyState is "loading"
        addEventListener("DOMContentLoaded", @start.bind(this), false)
      else
        @start()
      @installed = true

  start: ->
    unless @started
      @getController().start()
      @started = true

  run: ->
    @getController().processElements()

  process: (elements...) ->
    for element in elements
      @getController().processElement(element)
    elements.length

  getController: ->
    @controller ?= new LocalTime.Controller


LocalTime.install()
