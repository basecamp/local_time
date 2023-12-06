import LocalTime from "local_time"

const { addTimeEl, assert, defer, getText, setText, test, testAsync, testGroup, triggerEvent } = LocalTime.TestHelpers

testGroup("localized", () => {
  for (var id of [ "one", "two", "past", "future" ]) {
    test(id, () => {
      assertLocalized(id)
    })
  }

  test("date", () => {
    assertLocalized("date", "date")
  })

  test("unparseable time", () => {
    const el = addTimeEl({ format: "%Y", datetime: ":(" })
    setText(el, "2013")
    assert.equal(getText(el), "2013")
  })
})

test("processed timestamp", () => {
  const el = addTimeEl({ type: "time-or-date", datetime: moment().toISOString() })
  assert.notOk(el.getAttribute("data-processed-at"))
  LocalTime.run()
  assert.ok(el.getAttribute("data-processed-at"))
})

function assertLocalized(id, type = "time") {
  let compare, datetime, local, momentFormat
  switch (type) {
    case "time":
      momentFormat = "MMMM D, YYYY h:mma"
      compare = "toString"
      break
    case "date":
      momentFormat = "MMMM D, YYYY"
      compare = "dayOfYear"
      break
  }

  const el = document.getElementById(id)

  assert.ok(datetime = el.getAttribute("datetime"))
  assert.ok(local = getText(el))

  const datetimeParsed = moment(datetime)
  const localParsed = moment(local, momentFormat)

  assert.ok(datetimeParsed.isValid())
  assert.ok(localParsed.isValid())
  assert.equal(datetimeParsed[compare](), localParsed[compare]())
}
