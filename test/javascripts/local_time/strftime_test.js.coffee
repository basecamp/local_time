module "strftime"

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

for day in [0..30] by 6
  do (day) ->
    for hour in [0..24] by 6
      do (hour) ->

        for format, momentFormat of momentMap
          do (format, momentFormat) ->
            test "#{format} (+#{day} days, #{hour} hours)", ->
              now = moment().add("days", day).add("hours", hour)
              el  = addTimeEl {format, datetime: now.toISOString()}
              run()

              equal getText(el),
                if func = momentFormat.match(/(\w+)\(\)/)?[1]
                  now.toDate()[func]()
                else
                  now.format momentFormat

        test "%Z Timezone (+#{day} days, #{hour} hours)", ->
          now = moment().add("days", day).add("hours", hour)
          el  = addTimeEl format: "%Z", datetime: now.toISOString()
          run()

          text = getText el
          ok /^\w{3,4}$/.test(text), "#{text} doesn't look like a timezone"

ordinalMap =
  "st": [1,11,21,31]
  "nd": [2,12,22]
  "rd": [3,13,23]
  "th": [4,5,6,7,8,9,10,14,15,16,17,18,19,20,30]

for expectedOrdinal, days of ordinalMap
  do (days, expectedOrdinal) ->
    for day in days
      do (day) ->
        test "%E", ->
          date = new Date(2014, 0, day)
          el  = addTimeEl {format: "%E", datetime: date.toISOString()}
          run()

          equal getText(el), day + expectedOrdinal
