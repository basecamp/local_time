#= require qunit
#= require moment
#= require local_time
#= require_directory ./unit
#= require_self

@addTimeEl = (format = "%Y", datetime = "2013-11-12T12:13:00Z") ->
  el = document.createElement "time"
  el.setAttribute "data-local", "time"
  el.setAttribute "data-format", format
  el.setAttribute "datetime", datetime
  document.body.appendChild el
  el

@triggerEvent = (name, el = document) ->
  event = document.createEvent "Events"
  event.initEvent name, true, true
  el.dispatchEvent event

@run = ->
  triggerEvent "time:elapse"
