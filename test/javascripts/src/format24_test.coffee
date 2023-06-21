import LocalTime from "local_time"

{addTimeEl, assert, defer, getText, testAsync, testGroup} = LocalTime.TestHelpers
{config} = LocalTime

testGroup "format24 (24h time)", ->
  testAsync "default behavior", (done) ->
    now = moment()

    el = addTimeEl format: "%-l:%M%P", format24: "%H:%M", datetime: now.toISOString()
    defer ->
      assert.equal getText(el), now.format("h:mma")
      done()

  testAsync "turned off", (done) ->
    now = moment()
    originalFormat24 = config.format24
    config.format24 = false

    el = addTimeEl format: "%-l:%M%P", format24: "%H:%M", datetime: now.toISOString()
    defer ->
      assert.equal getText(el), now.format("h:mma")
      config.format24 = originalFormat24
      done()

  testAsync "turned on", (done) ->
    now = moment()
    originalFormat24 = config.format24
    config.format24 = true

    el = addTimeEl format: "%-l:%M%P", format24: "%H:%M", datetime: now.toISOString()
    defer ->
      assert.equal getText(el), now.format("H:mm")
      config.format24 = originalFormat24
      done()

  testAsync "fallback for missing data-format24 values", (done) ->
    now = moment()
    originalFormat24 = config.format24
    config.format24 = true

    el = addTimeEl format: "%-l:%M%P", datetime: now.toISOString()
    defer ->
      assert.equal getText(el), now.format("h:mma")
      config.format24 = originalFormat24
      done()
