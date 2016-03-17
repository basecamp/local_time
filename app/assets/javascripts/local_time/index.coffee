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
      @controller = new LocalTime.Controller
      @controller.start()
      @started = true

  run: ->
    @start()
    @controller.processElements()

  process: (elements...) ->
    for element in elements
      @controller.processElement(element)
    elements.length

LocalTime.install()
