import LocalTime from "local_time"

LocalTime.start()

LocalTime.TestHelpers = {
  assert: QUnit.assert,
  testGroup: QUnit.module,
  test: QUnit.test,

  testAsync(name, callback) {
    QUnit.test(name, (assert) => {
      const done = assert.async()
      callback(done)
    })
  },

  addTimeEl(param = {}) {
    let { format, type, datetime, format24 } = param
    if (!format) format = "%Y"
    if (!type) type = "time"
    if (!datetime) datetime = "2013-11-12T12:13:00Z"

    const el = document.createElement("time")
    el.setAttribute("data-local", type)
    el.setAttribute("data-format", format)
    el.setAttribute("datetime", datetime)
    if (format24) el.setAttribute("data-format24", format24)

    document.body.appendChild(el)
    return el
  },

  setText(el, text) {
    el.textContent = text
  },

  getText(el) {
    // innerHTML works in all browsers so using it ensures we're
    // reading the text content, not a potentially arbitrary property.
    return el.innerHTML
  },

  getTitle(el) {
    return el.getAttribute("title")
  },

  triggerEvent(name, el = document) {
    const event = document.createEvent("Events")
    event.initEvent(name, true, true)
    el.dispatchEvent(event)
  },

  defer(callback) {
    setTimeout(callback, 1)
  },

  stubNow(dateString, callback) {
    const originalNow = moment.now
    try {
      moment.now = () => new Date(dateString).getTime()
      callback()
    } finally {
      moment.now = originalNow
    }
  }
}
