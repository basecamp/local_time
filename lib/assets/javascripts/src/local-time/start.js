import LocalTime from "./local_time"

let started = false

function domReady() {
  if (document.attachEvent) {
    return document.readyState === "complete"
  } else {
    return document.readyState !== "loading"
  }
}

function nextFrame(fn) {
  return (typeof requestAnimationFrame === "function" ? requestAnimationFrame(fn) : setTimeout(fn, 17))
}

function startController() {
  const controller = LocalTime.getController()
  controller.start()
}

LocalTime.start = () => {
  if (started) {
    LocalTime.run()
  } else {
    started = true
    if (typeof MutationObserver !== "undefined" && MutationObserver !== null || domReady()) {
      startController()
    } else {
      nextFrame(startController)
    }
  }
}

LocalTime.processing = () => LocalTime.getController().started

if (window.LocalTime === LocalTime) {
  LocalTime.start()
}
