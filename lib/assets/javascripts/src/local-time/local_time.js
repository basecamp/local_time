/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
var LocalTime = {
  config: {},

  run() {
    return this.getController().processElements();
  },

  process(...elements) {
    for (var element of Array.from(elements)) {
      this.getController().processElement(element);
    }
    return elements.length;
  },

  getController() {
    return this.controller != null ? this.controller : (this.controller = new LocalTime.Controller);
  }
};

export default LocalTime;
