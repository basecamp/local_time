if window.LocalTime is LocalTime
  start = ->
    LocalTime.start()

  defer = (fn) ->
    window.requestAnimationFrame?(fn) ? setTimeout(fn, 16)

  if document.readyState is "loading"
    addEventListener("DOMContentLoaded", start, false)
  else
    defer(start)
