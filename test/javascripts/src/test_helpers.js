import LocalTime from "local_time"

LocalTime.start()

LocalTime.TestHelpers =
  assert: QUnit.assert
  testGroup: QUnit.module
  test: QUnit.test

  testAsync: (name, callback) ->
    QUnit.test name, (assert) ->
      done = assert.async()
      callback(done)

  addTimeEl: ({format, type, datetime, format24} = {}) ->
    format ?= "%Y"
    type ?= "time"
    datetime ?= "2013-11-12T12:13:00Z"

    el = document.createElement "time"
    el.setAttribute "data-local", type
    el.setAttribute "data-format", format
    el.setAttribute "datetime", datetime
    if format24 then el.setAttribute "data-format24", format24

    document.body.appendChild el
    el

  setText: (el, text) ->
    el.textContent = text

  getText: (el) ->
    # innerHTML works in all browsers so using it ensures we're
    # reading the text content, not a potentially arbitrary property.
    el.innerHTML

  getTitle: (el) ->
    el.getAttribute("title")

  triggerEvent: (name, el = document) ->
    event = document.createEvent "Events"
    event.initEvent name, true, true
    el.dispatchEvent event

  defer: (callback) ->
    setTimeout(callback, 1)
