started = false

domReady = ->
  if document.attachEvent
    document.readyState is "complete"
  else
    document.readyState isnt "loading"

nextFrame = (fn) ->
  requestAnimationFrame?(fn) ? setTimeout(fn, 17)

startController = ->
  controller = LocalTime.getController()
  controller.start()

LocalTime.start = ->
  unless started
    started = true
    if MutationObserver? or domReady()
      startController()
    else
      nextFrame(startController)

if window.LocalTime is LocalTime
  LocalTime.start()
