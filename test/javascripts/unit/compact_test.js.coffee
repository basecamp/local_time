module "compact"

test "30 minutes ago", ->
  assertPastCompactDateTime "12:30am", "minutes", 30

test "1 hour ago", ->
  assertPastCompactDateTime "12:00am", "hours", 1

test "1 hour and 1 minute ago", ->
  time = moment().subtract("days", 1).format "MMM D"
  assertPastCompactDateTime time, "minutes", 61

test "yesterday", ->
  time = moment().subtract("days", 1).format "MMM D"
  assertPastCompactDateTime time, "days", 1

test "last month", ->
  time = moment().subtract("months", 1).format "MMM D"
  assertPastCompactDateTime time, "months", 1

test "last year", ->
  time = moment().subtract("years", 1).format 'MMM D, \'YY'
  assertPastCompactDateTime time, "years", 1

test "next year", ->
  time = moment().add("years", 1).format 'MMM D, \'YY'
  assertFutureCompactDateTime time, "years", 1

assertPastCompactDateTime = (string, unit, amount) ->
  assertDateTime string, moment({hour:1}).subtract(unit, amount).utc().toISOString()

assertFutureCompactDateTime = (string, unit, amount) ->
  assertDateTime string, moment({hour:1}).add(unit, amount).utc().toISOString()

assertDateTime = (string, time) ->
  el = document.getElementById "compact"
  el.setAttribute "data-local", "compact"
  el.setAttribute "datetime", time
  run()
  equal el.innerText, string

