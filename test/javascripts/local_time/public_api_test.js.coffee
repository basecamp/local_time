module "public API"

test "strftime", ->
  datetime = "2013-11-12T12:13:00Z"
  time = new Date Date.parse datetime
  format = "%B %e, %Y %l:%M%P"
  results = LocalTime.strftime time, format

  ok results

  datetimeParsed = moment datetime
  localParsed = moment results, "MMMM D, YYYY h:mma"

  ok datetimeParsed.isValid()
  ok localParsed.isValid()
  equal datetimeParsed.toString(), localParsed.toString()

test "relativeTimeAgo", ->
  time = moment().subtract("minutes", 42).toDate()
  results = LocalTime.relativeTimeAgo(time)
  equal results, "42 minutes ago"
