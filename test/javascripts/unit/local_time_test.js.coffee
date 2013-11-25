module "localized"

for id in ["one", "two", "past", "future"]
  test id, ->
    assertLocalized id

test "date", ->
  assertLocalized "date", "date"

test "unparseable time", ->
  el = addTimeEl "%Y", ":("
  el.innerText = "2013"
  run()
  equal el.innerText, "2013"


assertLocalized = (id, type = "time") ->
  switch type
    when "time"
      momentFormat = "MMMM D, YYYY h:mma"
      compare = "toString"
    when "date"
      momentFormat = "MMMM D, YYYY"
      compare = "dayOfYear"

  el = document.getElementById id

  ok datetime = el.getAttribute "datetime"
  ok local = el.innerText

  datetimeParsed = moment datetime
  localParsed = moment local, momentFormat

  ok datetimeParsed.isValid()
  ok localParsed.isValid()
  equal datetimeParsed[compare](), localParsed[compare]()
