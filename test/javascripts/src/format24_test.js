import LocalTime from "local_time"

const { addTimeEl, assert, defer, getText, testAsync, testGroup, getTitle } = LocalTime.TestHelpers
const { config } = LocalTime

testGroup("format24 (24h time)", () => {
  testAsync("default behavior", (done) => {
    const now = moment()

    const el = addTimeEl({ format: "%-l:%M%P", format24: "%H:%M", datetime: now.toISOString() })
    defer(() => {
      assert.equal(getText(el), now.format("h:mma"))
      done()
    })
  })

  testAsync("turned off", (done) => {
    const now = moment()
    const originalFormat24 = config.useFormat24
    config.useFormat24 = false

    const el = addTimeEl({ format: "%-l:%M%P", format24: "%H:%M", datetime: now.toISOString() })
    defer(() => {
      assert.equal(getText(el), now.format("h:mma"))
      config.useFormat24 = originalFormat24
      done()
    })
  })

  testAsync("turned on", (done) => {
    const now = moment()
    const originalFormat24 = config.useFormat24
    config.useFormat24 = true

    const el = addTimeEl({ format: "%-l:%M%P", format24: "%H:%M", datetime: now.toISOString() })
    defer(() => {
      assert.equal(getText(el), now.format("HH:mm"))
      config.useFormat24 = originalFormat24
      done()
    })
  })

  testAsync("fallback for missing data-format24 values", (done) => {
    const now = moment()
    const originalFormat24 = config.useFormat24
    config.useFormat24 = true

    const el = addTimeEl({ format: "%-l:%M%P", datetime: now.toISOString() })
    defer(() => {
      assert.equal(getText(el), now.format("h:mma"))
      config.useFormat24 = originalFormat24
      done()
    })
  })

  testAsync("turned off for relative time elements", (done) => {
    const ago = moment().subtract("days", 5)
    const originalFormat24 = config.useFormat24
    config.useFormat24 = false

    const el = addTimeEl({ type: "time-ago", datetime: ago.toISOString() })
    defer(() => {
      assert.equal(getText(el), `${ago.format("dddd")} at ${ago.format("h:mma")}`)
      config.useFormat24 = originalFormat24
      done()
    })
  })

  testAsync("turned on for relative time elements", (done) => {
    const ago = moment().subtract("days", 5)
    const originalFormat24 = config.useFormat24
    config.useFormat24 = true

    const el = addTimeEl({ type: "time-ago", datetime: ago.toISOString() })
    defer(() => {
      assert.equal(getText(el), `${ago.format("dddd")} at ${ago.format("HH:mm")}`)
      config.useFormat24 = originalFormat24
      done()
    })
  })

  testAsync("element title when turned off", (done) => {
    const ago = moment().subtract("days", 5)
    const originalFormat24 = config.useFormat24
    config.useFormat24 = false

    const el = addTimeEl({ type: "time-ago", datetime: ago.toISOString() })
    defer(() => {
      const regex = new RegExp(ago.format('MMMM D, YYYY [at] h:mma') + " (\\w{3,4}|UTC[+-]d+)")
      assert.ok(regex.test(getTitle(el)), `'${getTitle(el)}' doesn't look correct, it should match regex ${regex}`)
      config.useFormat24 = originalFormat24
      done()
    })
  })

  testAsync("element title when turned on", (done) => {
    const ago = moment().subtract("days", 5)
    const originalFormat24 = config.useFormat24
    config.useFormat24 = true

    const el = addTimeEl({ type: "time-ago", datetime: ago.toISOString() })
    defer(() => {
      const regex = new RegExp(ago.format('MMMM D, YYYY [at] HH:mm') + " (\\w{3,4}|UTC[+-]d+)")
      assert.ok(regex.test(getTitle(el)), `'${getTitle(el)}' doesn't look correct, it should match regex ${regex}`)
      config.useFormat24 = originalFormat24
      done()
    })
  })
})
