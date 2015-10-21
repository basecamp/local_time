module "public API"

for name in ["relativeDate", "relativeTimeAgo", "relativeTimeOrDate", "relativeWeekday"]
  do (name) ->
    method = LocalTime[name]
    test "##{name}", ->
      ok method(new Date())

{strftime, updateElement} = LocalTime

test "#strftime", =>
  ok strftime(new Date(), "%Y")

test "#updateElement", =>
  el = createTimeEl()
  equal getText(el), ""

  updateElement(el)
  equal getText(el), "2013"
