const LocalTime = {
  config: {},

  run() {
    this.getController().processElements()
  },

  process(...elements) {
    for (const element of elements) {
      this.getController().processElement(element)
    }
    return elements.length
  },

  getController() {
    return this.controller ? this.controller : (this.controller = new LocalTime.Controller)
  }
}

export default LocalTime
