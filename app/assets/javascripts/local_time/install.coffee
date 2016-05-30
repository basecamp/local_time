install = ->
  LocalTime.start()

defer = (fn) ->
  window.requestAnimationFrame?(fn) ? setTimeout(fn, 16)

if document.readyState is "loading"
  addEventListener("DOMContentLoaded", install, false)
else
  defer(install)
