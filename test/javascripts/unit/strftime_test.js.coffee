module "strftime"

momentMap =
  "%a": "ddd"
  "%A": "dddd"
  "%b": "MMM"
  "%B": "MMMM"
  "%c": "toString()"
  "%d": "D"
  "%e": "DD"
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

for hour in [0..24] by 6
  do (hour) ->
    for format, momentFormat of momentMap
      do (format, momentFormat) ->
        test "#{format} (+#{hour} hours)", ->
          now = moment().add "hours", hour
          el  = addTimeEl format, now.toISOString()
          run()

          equal el.innerText,
            if func = momentFormat.match(/(\w+)\(\)/)?[1]
              now.toDate()[func]()
            else
              now.format momentFormat

