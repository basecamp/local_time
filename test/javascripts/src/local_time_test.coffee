{addTimeEl, assert, defer, getText, setText, test, testAsync, testGroup, triggerEvent} = LocalTime.TestHelpers

testGroup "localized", ->
  for id in ["one", "two", "past", "future"]
    test id, ->
      assertLocalized id

  test "date", ->
    assertLocalized "date", "date"

  test "unparseable time", ->
    el = addTimeEl format: "%Y", datetime: ":("
    setText el, "2013"
    assert.equal getText(el), "2013"


assertLocalized = (id, type = "time") ->
  switch type
    when "time"
      momentFormat = "MMMM D, YYYY h:mma"
      compare = "toString"
    when "date"
      momentFormat = "MMMM D, YYYY"
      compare = "dayOfYear"

  el = document.getElementById id

  assert.ok datetime = el.getAttribute "datetime"
  assert.ok local = getText el
  assert.equal el.getAttribute("aria-label"), local

  datetimeParsed = moment datetime
  localParsed = moment local, momentFormat

  assert.ok datetimeParsed.isValid()
  assert.ok localParsed.isValid()
  assert.equal datetimeParsed[compare](), localParsed[compare]()
