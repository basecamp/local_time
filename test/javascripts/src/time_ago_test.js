import LocalTime from "local_time"

const { addTimeEl, assert, defer, getText, setText, test, testAsync, testGroup, triggerEvent } = LocalTime.TestHelpers

testGroup("time ago", () => {
  test("a second ago", () => {
    assertTimeAgo("a second ago", "seconds", 9)
  })

  test("seconds ago", () => {
    assertTimeAgo("44 seconds ago", "seconds", 44)
  })

  test("a minute ago", () => {
    assertTimeAgo("a minute ago", "seconds", 89)
  })

  test("minutes ago", () => {
    assertTimeAgo("44 minutes ago", "minutes", 44)
  })

  test("an hour ago", () => {
    assertTimeAgo("an hour ago", "minutes", 89)
  })

  test("hours ago", () => {
    assertTimeAgo("23 hours ago", "hours", 23)
  })

  test("yesterday", () => {
    const time = moment().subtract("days", 1).format("h:mma")
    assertTimeAgo(`yesterday at ${time}`, "days", 1)
  })

  test("tomorrow", () => {
    const time = moment().add("days", 1).format("h:mma")
    assertTimeAgo(`tomorrow at ${time}`, "days", -1)
  })

  test("last week", () => {
    const ago = moment().subtract("days", 5)
    const day = ago.format("dddd")
    const time = ago.format("h:mma")

    assertTimeAgo(`${day} at ${time}`, "days", 5)
  })

  test("this year", () => {
    const clock = sinon.useFakeTimers(new Date(2013, 11, 11, 11, 11).getTime(), "Date")
    const date = moment().subtract("days", 7).format("MMM D")
    assertTimeAgo(`on ${date}`, "days", 7)
    clock.restore()
  })

  test("last year", () => {
    const date = moment().subtract("days", 366).format("MMM D, YYYY")
    assertTimeAgo(`on ${date}`, "days", 366)
  })

  test("next year", () => {
    const date = moment().add("days", 366).format("MMM D, YYYY")
    assertTimeAgo(`on ${date}`, "days", -366)
  })
})

function assertTimeAgo(string, unit, amount) {
  const el = document.getElementById("ago")
  el.setAttribute("data-local", "time-ago")
  el.setAttribute("datetime", moment().subtract(unit, amount).utc().toISOString())
  LocalTime.run()
  assert.equal(getText(el), string)
}
