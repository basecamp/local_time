import LocalTime from "local_time"

{addTimeEl, assert, defer, getText, setText, test, testAsync, testGroup, triggerEvent} = LocalTime.TestHelpers

momentMap =
  "%a": "ddd"
  "%A": "dddd"
  "%b": "MMM"
  "%B": "MMMM"
  "%c": "toString()"
  "%d": "DD"
  "%-d": "D"
  "%e": "D"
  "%H": "HH"
  "%-H": "H"
  "%I": "hh"
  "%-I": "h"
  "%l": "h"
  "%m": "MM"
  "%-m": "M"
  "%M": "mm"
  "%-M": "m"
  "%p": "A"
  "%P": "a"
  "%S": "ss"
  "%-S": "s"
  "%w": "e"
  "%y": "YY"
  "%Y": "YYYY"

stubToLocaleString = (stubImplementation) ->
  original = Date.prototype.toLocaleString
  Date.prototype.toLocaleString = stubImplementation
  restore: -> Date.prototype.toLocaleString = original

stubDateToString = (stubImplementation) ->
  original = Date.prototype.toString
  Date.prototype.toString = stubImplementation
  restore: -> Date.prototype.toString = original

testGroup "strftime", ->
  for day in [0..30] by 6
    do (day) ->
      for hour in [0..24] by 6
        do (hour) ->

          for format, momentFormat of momentMap
            do (format, momentFormat) ->
              test "#{format} (+#{day} days, #{hour} hours)", ->
                now = moment().add("days", day).add("hours", hour)
                el  = addTimeEl {format, datetime: now.toISOString()}
                LocalTime.process(el)

                assert.equal getText(el),
                  if func = momentFormat.match(/(\w+)\(\)/)?[1]
                    now.toDate()[func]()
                  else
                    now.format momentFormat

          test "%Z Timezone (+#{day} days, #{hour} hours)", ->
            now = moment().add("days", day).add("hours", hour)
            el  = addTimeEl format: "%Z", datetime: now.toISOString()
            LocalTime.process(el)

            text = getText el
            assert.ok /^(\w{3,4}|UTC[\+\-]\d+)$/.test(text), "'#{text}' doesn't look like a timezone. System date: '#{new Date}'"

testGroup "strftime time zones", ->
  for timeZone in Object.keys(LocalTime.knownEdgeCaseTimeZones)
    do (timeZone) ->
      test "edge-case time zone #{timeZone}", ->
        stub = stubToLocaleString -> "Thu Nov 30 2023 14:22:57 GMT-0000 (#{timeZone})"

        el = addTimeEl format: "%Z", datetime: "2023-11-30T14:22:57Z"
        LocalTime.process(el)

        assert.equal getText(el), LocalTime.knownEdgeCaseTimeZones[timeZone]

        stub.restore()

  test "time zones Intl can abbreviate are parsed correctly", ->
    stub = stubToLocaleString (_, options) ->
      if options.timeZoneName == "long"
        "Thu Nov 30 2023 14:22:57 GMT-0800 (Alaska Daylight Time)" # not a known edge-case
      else if options.timeZoneName == "short"
        "11/30/2023, 2:22:57 PM AKDT" # possible to abbreviate

    el = addTimeEl format: "%Z", datetime: "2023-11-30T14:22:57Z"
    LocalTime.process(el)

    assert.equal getText(el), "AKDT"

    stub.restore()

  test "time zones Intl can't abbreviate are parsed by our heuristic", ->
    stub = stubToLocaleString (_, options) ->
      if options.timeZoneName == "long"
        "Thu Nov 30 2023 14:22:57 GMT+0700 (Central Twilight Time)" # not a known edge-case
      else if options.timeZoneName == "short"
        "11/30/2023, 2:22:57 PM GMT+7" # not possible to abbreviate

    el = addTimeEl format: "%Z", datetime: "2023-11-30T14:22:57Z"
    LocalTime.process(el)

    text = getText el
    assert.ok /^(\w{3,4}|UTC[\+\-]\d+)$/.test(text), "'#{text}' doesn't look like a timezone. System date: '#{new Date}'"

  test "time zones Intl can't abbreviate and our heuristic can't parse display GMT offset", ->
    dateToStringStub = stubDateToString -> ""
    toLocaleStringStub = stubToLocaleString (_, options) ->
      if options.timeZoneName == "long"
        "Thu Nov 30 2023 14:22:57 GMT+0700 (Central Twilight Time)" # not a known edge-case
      else if options.timeZoneName == "short"
        "11/30/2023, 2:22:57 PM GMT+7" # not possible to abbreviate

    el = addTimeEl format: "%Z", datetime: "2023-11-30T14:22:57Z"
    LocalTime.process(el)

    assert.equal getText(el), "GMT+7"

    dateToStringStub.restore()
    toLocaleStringStub.restore()
