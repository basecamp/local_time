module "relative date"

test "this year", ->
  now = moment()
  el = addTimeEl type: "date", datetime: now.toISOString()
  run()

  equal getText(el), now.format("MMM D")

test "last year", ->
  before = moment().subtract("years", 1).subtract("days", 1)
  el = addTimeEl type: "date", datetime: before.toISOString()
  run()

  equal getText(el), before.format("MMM D, YYYY")


module "relative time or date"


test "today", ->
  now = moment()
  el = addTimeEl type: "time-or-date", datetime: now.toISOString()
  run()

  equal getText(el), now.format("h:mma")

test "before today", ->
  before = moment().subtract("days", 1)
  el = addTimeEl type: "time-or-date", datetime: before.toISOString()
  run()

  equal getText(el), before.format("MMM D")


module "relative weekday"


test "today", ->
  now = moment()
  el = addTimeEl type: "weekday", datetime: now.toISOString()
  run()

  equal getText(el), "Today"

test "yesterday", ->
  yesterday = moment().subtract("days", 1)
  el = addTimeEl type: "weekday", datetime: yesterday.toISOString()
  run()

  equal getText(el), "Yesterday"

test "this week", ->
  recent = moment().subtract("days", 3)
  el = addTimeEl type: "weekday", datetime: recent.toISOString()
  run()

  equal getText(el), recent.format("dddd")

test "before this week", ->
  before = moment().subtract("days", 8)
  el = addTimeEl type: "weekday", datetime: before.toISOString()
  run()

  equal getText(el), ""

module "relative weekday or date"


test "today", ->
  now = moment()
  el = addTimeEl type: "weekday-or-date", datetime: now.toISOString()
  run()

  equal getText(el), "Today"

test "yesterday", ->
  yesterday = moment().subtract("days", 1)
  el = addTimeEl type: "weekday-or-date", datetime: yesterday.toISOString()
  run()

  equal getText(el), "Yesterday"

test "this week", ->
  recent = moment().subtract("days", 3)
  el = addTimeEl type: "weekday-or-date", datetime: recent.toISOString()
  run()

  equal getText(el), recent.format("dddd")

test "before this week", ->
  before = moment().subtract("days", 8)
  el = addTimeEl type: "weekday-or-date", datetime: before.toISOString()
  run()

  equal getText(el), before.format("MMM D")
