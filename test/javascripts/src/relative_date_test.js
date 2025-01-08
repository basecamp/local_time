import LocalTime from "local_time"

const { addTimeEl, assert, defer, getText, testAsync, testGroup, stubNow } = LocalTime.TestHelpers

testGroup("relative date", () => {
  testAsync("this year", (done) => {
    const now = moment()
    const el = addTimeEl({ type: "date", datetime: now.toISOString() })
    defer(() => {
      assert.equal(getText(el), now.format("MMM D"))
      done()
    })
  })

  testAsync("last year", (done) => {
    const before = moment().subtract("years", 1).subtract("days", 1)
    const el = addTimeEl({ type: "date", datetime: before.toISOString() })
    defer(() => {
      assert.equal(getText(el), before.format("MMM D, YYYY"))
      done()
    })
  })
})

testGroup("relative time or date", () => {
  testAsync("today", (done) => {
    const now = moment()
    const el = addTimeEl({ type: "time-or-date", datetime: now.toISOString() })
    defer(() => {
      assert.equal(getText(el), now.format("h:mma"))
      done()
    })
  })

  testAsync("before today", (done) => {
    const before = moment().subtract("days", 1)
    const el = addTimeEl({ type: "time-or-date", datetime: before.toISOString() })
    defer(() => {
      assert.equal(getText(el), before.format("MMM D"))
      done()
    })
  })
})

testGroup("relative weekday", () => {
  testAsync("today", (done) => {
    const now = moment()
    const el = addTimeEl({ type: "weekday", datetime: now.toISOString() })
    defer(() => {
      assert.equal(getText(el), "today")
      done()
    })
  })

  testAsync("yesterday", (done) => {
    const yesterday = moment().subtract("days", 1)
    const el = addTimeEl({ type: "weekday", datetime: yesterday.toISOString() })
    defer(() => {
      assert.equal(getText(el), "yesterday")
      done()
    })
  })

  testAsync("this week", (done) => {
    const recent = moment().subtract("days", 3)
    const el = addTimeEl({ type: "weekday", datetime: recent.toISOString() })
    defer(() => {
      assert.equal(getText(el), recent.format("dddd"))
      done()
    })
  })

  testAsync("before this week", (done) => {
    const before = moment().subtract("days", 8)
    const el = addTimeEl({ type: "weekday", datetime: before.toISOString() })
    defer(() => {
      assert.equal(getText(el), "")
      done()
    })
  })
})

testGroup("relative weekday or date", () => {
  testAsync("today", (done) => {
    const now = moment()
    const el = addTimeEl({ type: "weekday-or-date", datetime: now.toISOString() })
    defer(() => {
      assert.equal(getText(el), "today")
      done()
    })
  })

  testAsync("yesterday", (done) => {
    const yesterday = moment().subtract("days", 1)
    const el = addTimeEl({ type: "weekday-or-date", datetime: yesterday.toISOString() })
    defer(() => {
      assert.equal(getText(el), "yesterday")
      done()
    })
  })

  testAsync("this week", (done) => {
    const recent = moment().subtract("days", 3)
    const el = addTimeEl({ type: "weekday-or-date", datetime: recent.toISOString() })
    defer(() => {
      assert.equal(getText(el), recent.format("dddd"))
      done()
    })
  })

  testAsync("before this week", (done) => {
    stubNow(`${moment().year()}-03-20`, () => {
      const before = moment().subtract("days", 8)
      const el = addTimeEl({ type: "weekday-or-date", datetime: before.toISOString() })
      defer(() => {
        assert.equal(getText(el), before.format("MMM D"))
        done()
      })
    })
  })
})
