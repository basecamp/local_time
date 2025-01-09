import LocalTime from "local_time"

const { addTimeEl, assert, getText, stubNow, test, testGroup } = LocalTime.TestHelpers

testGroup("RelativeTime#toString", () => {
  test("around now", () => {
    assertPast("a second ago", "milliseconds", 100)
    assertFuture("in a second", "milliseconds", 100)
  })

  test("one second ago", () => {
    assertPast("a second ago", "seconds", 1)
  })

  test("one second from now", () => {
    assertFuture("in a second", "seconds", 1)
  })

  test("a few second ago", () => {
    assertPast("9 seconds ago", "seconds", 9)
  })

  test("a few seconds from now", () => {
    assertFuture("in 9 seconds", "seconds", 9)
  })

  test("multiple seconds ago", () => {
    assertPast("44 seconds ago", "seconds", 44)
  })

  test("multiple seconds from now", () => {
    assertFuture("in 44 seconds", "seconds", 44)
  })

  test("a minute ago", () => {
    assertPast("a minute ago", "seconds", 89)
  })

  test("a minute from now", () => {
    assertFuture("in a minute", "seconds", 89)
  })

  test("minutes ago", () => {
    assertPast("44 minutes ago", "minutes", 44)
  })

  test("minutes from now", () => {
    assertFuture("in 44 minutes", "minutes", 44)
  })

  test("an hour ago", () => {
    assertPast("an hour ago", "minutes", 89)
  })

  test("an hour from now", () => {
    assertFuture("in an hour", "minutes", 89)
  })

  test("hours ago", () => {
    assertPast("23 hours ago", "hours", 23)
  })

  test("hours from now", () => {
    assertFuture("in 23 hours", "hours", 23)
  })

  test("yesterday", () => {
    const time = moment().subtract("days", 1).format("h:mma")
    assertPast(`yesterday at ${time}`, "days", 1)
  })

  test("tomorrow", () => {
    const time = moment().add("days", 1).format("h:mma")
    assertFuture(`tomorrow at ${time}`, "days", 1)
  })

  test("last week", () => {
    const ago = moment().subtract("days", 5)
    const day = ago.format("dddd")
    const time = ago.format("h:mma")

    assertPast(`${day} at ${time}`, "days", 5)
  })

  test("next week", () => {
    const ago = moment().add("days", 5)
    const day = ago.format("dddd")
    const time = ago.format("h:mma")

    assertFuture(`${day} at ${time}`, "days", 5)
  })

  test("past date this year", () => {
    stubNow("2013-11-11", () => {
      const date = moment().subtract("days", 7).format("MMM D")
      assertPast(`on ${date}`, "days", 7)
    })
  })

  test("future date this year", () => {
    stubNow("2013-11-11", () => {
      const date = moment().add("days", 7).format("MMM D")
      assertFuture(`on ${date}`, "days", 7)
    })
  })

  test("last year", () => {
    const date = moment().subtract("days", 366).format("MMM D, YYYY")
    assertPast(`on ${date}`, "days", 366)
  })

  test("next year", () => {
    const date = moment().add("days", 366).format("MMM D, YYYY")
    assertFuture(`on ${date}`, "days", 366)
  })

  test("with past prefixes", () => {
    assertPast("ended 2 hours ago", "hours", 2, { futurePrefix: "ends", pastPrefix: "ended" })
  })

  test("with now prefixes", () => {
    assertPast("ended a second ago", "milliseconds", 500, { futurePrefix: "ends", pastPrefix: "ended" })
  })

  test("with future prefixes", () => {
    assertFuture("ends in 2 hours", "hours", 2, { futurePrefix: "ends", pastPrefix: "ended" })
  })
})

function assertFuture(string, unit, amount, options = {}) {
  assertPast(string, unit, amount * -1, options)
}

function assertPast(string, unit, amount, options = {}) {
  const datetime = moment().subtract(amount, unit).utc().toISOString()

  const relativeElement = addTimeEl({ type: "relative", datetime, ...options })
  const timeAgoElement = addTimeEl({ type: "time-ago", datetime, ...options })

  LocalTime.run()

  assert.equal(getText(relativeElement), string)
  assert.equal(getText(timeAgoElement), string)
}
