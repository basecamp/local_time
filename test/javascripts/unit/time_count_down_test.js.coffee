module "time count down"

test "9s ago", ->
  assertTimeCountDownPast "now", "seconds", 9

test "1m ago", ->
  assertTimeCountDownPast "now", "seconds", 89

test "59m ago", ->
  assertTimeCountDownPast "now", "minutes", 59

test "1h ago", ->
  assertTimeCountDownPast "now", "minutes", 60

test "1h5m ago", ->
  assertTimeCountDownPast "now", "minutes", 65


test "9s", ->
  assertTimeCountDownFuture "9s", "seconds", 9

test "1m", ->
  assertTimeCountDownFuture "1m", "seconds", 60

test "59m", ->
  assertTimeCountDownFuture "59m", "minutes", 59

test "1h", ->
  assertTimeCountDownFuture "1h", "minutes", 60

test "1h5m", ->
  assertTimeCountDownFuture "1h5m", "minutes", 65
  
assertTimeCountDownPast = (string, unit, amount) ->
  el = document.getElementById "count-down"
  el.setAttribute "data-local", "time-count-down"
  el.setAttribute "datetime", moment().subtract(unit, amount).utc().toISOString()
  run()
  equal getText(el), string

assertTimeCountDownFuture = (string, unit, amount) ->
  el = document.getElementById "count-down"
  el.setAttribute "data-local", "time-count-down"
  el.setAttribute "datetime", moment().add(unit, amount).utc().toISOString()
  run()
  equal getText(el), string

#highlight

test "close in 9s", ->
  assertTimeCountDownHighlight "close-soon", "seconds", 9

test "close in 5m10s", ->
  assertTimeCountDownHighlight "close-in-minutes", "seconds", 310

test "close in 16m", ->
  assertTimeCountDownHighlight "", "minutes", 16

test "closed", ->
  assertTimeCountDownHighlight "closed", "minutes", -16

assertTimeCountDownHighlight = (string, unit, amount) ->
  el = document.getElementById "count-down"
  el.setAttribute "data-local", "time-count-down"
  el.setAttribute "datetime", moment().add(unit, amount).utc().toISOString()
  run()
  equal el.getAttribute('tear-down'), string