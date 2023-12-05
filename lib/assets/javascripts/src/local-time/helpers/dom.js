/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS104: Avoid inline assignments
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
import LocalTime from "../local_time";

LocalTime.elementMatchesSelector = (function() {
  let left, left1, left2;
  const element = document.documentElement;
  const method = (left = (left1 = (left2 = element.matches != null ? element.matches : element.matchesSelector) != null ? left2 : element.webkitMatchesSelector) != null ? left1 : element.mozMatchesSelector) != null ? left : element.msMatchesSelector;

  return function(element, selector) {
    if ((element != null ? element.nodeType : undefined) === Node.ELEMENT_NODE) {
      return method.call(element, selector);
    }
  };
})();
