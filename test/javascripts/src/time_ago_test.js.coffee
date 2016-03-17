module "time ago"

test "a second ago", ->
  assertTimeAgo "a second ago", "seconds", 9

test "seconds ago", ->
  assertTimeAgo "44 seconds ago", "seconds", 44

test "a minute ago", ->
  assertTimeAgo "a minute ago", "seconds", 89

test "minutes ago", ->
  assertTimeAgo "44 minutes ago", "minutes", 44

test "an hour ago", ->
  assertTimeAgo "an hour ago", "minutes", 89

test "hours ago", ->
  assertTimeAgo "23 hours ago", "hours", 23

test "yesterday", ->
  time = moment().subtract("days", 1).format "h:mma"
  assertTimeAgo "yesterday at #{time}", "days", 1

test "tomorrow", ->
  time = moment().add("days", 1).format "h:mma"
  assertTimeAgo "tomorrow at #{time}", "days", -1

test "last week", ->
  ago  = moment().subtract "days", 5
  day  = ago.format "dddd"
  time = ago.format "h:mma"

  assertTimeAgo "#{day} at #{time}", "days", 5

test "this year", ->
  clock = sinon.useFakeTimers(new Date(2013,11,11,11,11).getTime(), "Date")
  date = moment().subtract("days", 7).format "MMM D"
  assertTimeAgo "on #{date}", "days", 7
  clock.restore()

test "last year", ->
  date = moment().subtract("days", 366).format "MMM D, YYYY"
  assertTimeAgo "on #{date}", "days", 366

test "next year", ->
  date = moment().add("days", 366).format "MMM D, YYYY"
  assertTimeAgo "on #{date}", "days", -366

assertTimeAgo = (string, unit, amount) ->
  el = document.getElementById "ago"
  el.setAttribute "data-local", "time-ago"
  el.setAttribute "datetime", moment().subtract(unit, amount).utc().toISOString()
  LocalTime.run()
  equal getText(el), string
