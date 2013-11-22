#= require qunit
#= require moment
#= require local_time
#= require_self

test "local time ", ->
  assertLocalTime "one"
  assertLocalTime "two"

test "local time in the past", ->
  assertLocalTime "past"

test "local time in the future", ->
  assertLocalTime "future"

assertLocalTime = (id, date = false) ->
  el = document.getElementById id

  ok datetime = el.getAttribute "datetime"
  ok local = el.innerText

  datetimeParsed = moment datetime
  localParsed = moment local, "MMMM D, YYYY h:mma"

  ok datetimeParsed.isValid()
  ok localParsed.isValid()
  equal datetimeParsed.toString(), localParsed.toString(), local
