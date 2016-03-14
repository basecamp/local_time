module "relative date"

test "this year", (assert) ->
  done = assert.async()
  now = moment()
  el = addTimeEl type: "date", datetime: now.toISOString()
  defer ->
    equal getText(el), now.format("MMM D")
    done()

test "last year", (assert) ->
  done = assert.async()
  before = moment().subtract("years", 1).subtract("days", 1)
  el = addTimeEl type: "date", datetime: before.toISOString()
  defer ->
    equal getText(el), before.format("MMM D, YYYY")
    done()

module "relative time or date"

test "today", (assert) ->
  done = assert.async()
  now = moment()
  el = addTimeEl type: "time-or-date", datetime: now.toISOString()
  defer ->
    equal getText(el), now.format("h:mma")
    done()

test "before today", (assert) ->
  done = assert.async()
  before = moment().subtract("days", 1)
  el = addTimeEl type: "time-or-date", datetime: before.toISOString()
  defer ->
    equal getText(el), before.format("MMM D")
    done()

module "relative weekday"

test "today", (assert) ->
  done = assert.async()
  now = moment()
  el = addTimeEl type: "weekday", datetime: now.toISOString()
  defer ->
    equal getText(el), "Today"
    done()

test "yesterday", (assert) ->
  done = assert.async()
  yesterday = moment().subtract("days", 1)
  el = addTimeEl type: "weekday", datetime: yesterday.toISOString()
  defer ->
    equal getText(el), "Yesterday"
    done()

test "this week", (assert) ->
  done = assert.async()
  recent = moment().subtract("days", 3)
  el = addTimeEl type: "weekday", datetime: recent.toISOString()
  defer ->
    equal getText(el), recent.format("dddd")
    done()

test "before this week", (assert) ->
  done = assert.async()
  before = moment().subtract("days", 8)
  el = addTimeEl type: "weekday", datetime: before.toISOString()
  defer ->
    equal getText(el), ""
    done()

module "relative weekday or date"

test "today", (assert) ->
  done = assert.async()
  now = moment()
  el = addTimeEl type: "weekday-or-date", datetime: now.toISOString()
  defer ->
    equal getText(el), "Today"
    done()

test "yesterday", (assert) ->
  done = assert.async()
  yesterday = moment().subtract("days", 1)
  el = addTimeEl type: "weekday-or-date", datetime: yesterday.toISOString()
  defer ->
    equal getText(el), "Yesterday"
    done()

test "this week", (assert) ->
  done = assert.async()
  recent = moment().subtract("days", 3)
  el = addTimeEl type: "weekday-or-date", datetime: recent.toISOString()
  defer ->
    equal getText(el), recent.format("dddd")
    done()

test "before this week", (assert) ->
  done = assert.async()
  before = moment().subtract("days", 8)
  el = addTimeEl type: "weekday-or-date", datetime: before.toISOString()
  defer ->
    equal getText(el), before.format("MMM D")
    done()
