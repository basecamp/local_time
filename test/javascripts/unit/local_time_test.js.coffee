test "local time", ->
  assertLocalized "one"
  assertLocalized "two"

test "local time in the past", ->
  assertLocalized "past"

test "local time in the future", ->
  assertLocalized "future"

test "local date", ->
  assertLocalized "date", "date"


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
