{addTimeEl, assert, defer, getText, setText, test, testAsync, testGroup, triggerEvent} = LocalTime.TestHelpers

momentMap =
  "%a": "ddd"
  "%A": "dddd"
  "%b": "MMM"
  "%B": "MMMM"
  "%c": "toString()"
  "%d": "DD"
  "%e": "D"
  "%H": "HH"
  "%I": "hh"
  "%l": "h"
  "%m": "MM"
  "%M": "mm"
  "%p": "A"
  "%P": "a"
  "%S": "ss"
  "%w": "e"
  "%y": "YY"
  "%Y": "YYYY"

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
