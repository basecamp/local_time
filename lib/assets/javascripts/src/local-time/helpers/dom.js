import LocalTime from "../local_time"

LocalTime.elementMatchesSelector = (() => {
  let left, left1, left2
  const element = document.documentElement
  const method = (left = (left1 = (left2 = element.matches != null ? element.matches : element.matchesSelector) != null ? left2 : element.webkitMatchesSelector) != null ? left1 : element.mozMatchesSelector) != null ? left : element.msMatchesSelector

  return (element, selector) => {
    if (element?.nodeType === Node.ELEMENT_NODE) {
      return method.call(element, selector)
    }
  }
})()
