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

          equal el.innerText,
            if func = momentFormat.match(/(\w+)\(\)/)?[1]
              now.toDate()[func]()
            else
              now.format momentFormat

addTimeEl = (format, datetime) ->
  el = document.createElement "time"
  el.setAttribute "data-local", "time"
  el.setAttribute "data-format", format
  el.setAttribute "datetime", datetime
  document.body.appendChild el
  run()
  el

run = ->
  event = document.createEvent "Events"
  event.initEvent "time:elapse", true, true
  document.dispatchEvent event
