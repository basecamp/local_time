import LocalTime from "../local_time"

LocalTime.elementMatchesSelector = (() => {
  const element = document.documentElement
  const method = element.matches ||
    element.matchesSelector ||
    element.webkitMatchesSelector ||
    element.mozMatchesSelector ||
    element.msMatchesSelector

  return (element, selector) => {
    if (element?.nodeType === Node.ELEMENT_NODE) {
      return method.call(element, selector)
    }
  }
})()
