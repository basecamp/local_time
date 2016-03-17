install = ->
  LocalTime.start()

if document.readyState is "loading"
  addEventListener("DOMContentLoaded", install, false)
else
  install()
