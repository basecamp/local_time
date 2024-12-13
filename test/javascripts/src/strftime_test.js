import LocalTime from "local_time"

const { addTimeEl, assert, defer, getText, setText, test, testAsync, testGroup, triggerEvent } = LocalTime.TestHelpers

const momentMap = {
  "%a": "ddd",
  "%A": "dddd",
  "%b": "MMM",
  "%B": "MMMM",
  "%c": "toString()",
  "%d": "DD",
  "%-d": "D",
  "%e": "D",
  "%H": "HH",
  "%-H": "H",
  "%I": "hh",
  "%-I": "h",
  "%l": "h",
  "%m": "MM",
  "%-m": "M",
  "%M": "mm",
  "%-M": "m",
  "%p": "A",
  "%P": "a",
  "%S": "ss",
  "%-S": "s",
  "%w": "e",
  "%y": "YY",
  "%Y": "YYYY"
}

function stubDateToLocaleString(stubImplementation, callback) {
  const original = Date.prototype.toLocaleString
  Date.prototype.toLocaleString = stubImplementation
  try {
    return callback()
  } finally {
    Date.prototype.toLocaleString = original
  }
}

function stubDateToString(stubImplementation, callback) {
  const original = Date.prototype.toString
  Date.prototype.toString = stubImplementation
  try {
    return callback()
  } finally {
    Date.prototype.toString = original
  }
}

testGroup("strftime", () => {
  for (let day = 0; day <= 30; day += 6) {
    for (let hour = 0; hour <= 24; hour += 6) {
      for (const format in momentMap) {
        if (Object.prototype.hasOwnProperty.call(momentMap, format)) {
          const momentFormat = momentMap[ format ]

          test(`${format} (+${day} days, ${hour} hours)`, () => {
            const now = moment().add("days", day).add("hours", hour)
            const el = addTimeEl({ format, datetime: now.toISOString() })
            LocalTime.process(el)

            if (momentFormat.includes("toString()")) {
              assert.equal(getText(el), now.toDate().toString())
            } else {
              assert.equal(getText(el), now.format(momentFormat))
            }
          })
        }
      }

      test(`%Z Timezone (+${day} days, ${hour} hours)`, () => {
        const now = moment().add("days", day).add("hours", hour)
        const el = addTimeEl({ format: "%Z", datetime: now.toISOString() })
        LocalTime.process(el)

        const text = getText(el)
        assert.ok(/^(\w{3,4}|UTC[\+\-]\d+)$/.test(text), `'${text}' doesn't look like a timezone. System date: '${new Date}'`)
      })
    }
  }
})

testGroup("strftime time zones", () => {
  for (var timeZone of Array.from(Object.keys(LocalTime.knownEdgeCaseTimeZones))) {
    ((timeZone => test(`edge-case time zone ${timeZone}`, () => {
      const stub = () => `Thu Nov 30 2023 14:22:57 GMT-0000 (${timeZone})`

      stubDateToLocaleString(stub, () => {
        const el = addTimeEl({ format: "%Z", datetime: "2023-11-30T14:22:57Z" })
        LocalTime.process(el)

        assert.equal(getText(el), LocalTime.knownEdgeCaseTimeZones[timeZone])
      })
    })))(timeZone)
  }

  test("time zones Intl can abbreviate are parsed correctly", () => {
    const stub = (_, options) => {
      if (options.timeZoneName === "long") {
        return "Thu Nov 30 2023 14:22:57 GMT-0800 (Alaska Daylight Time)" // not a known edge-case
      } else if (options.timeZoneName === "short") {
        return "11/30/2023, 2:22:57 PM AKDT" // possible to abbreviate
      }
    }

    stubDateToLocaleString(stub, () => {
      const el = addTimeEl({ format: "%Z", datetime: "2023-11-30T14:22:57Z" })
      LocalTime.process(el)

      assert.equal(getText(el), "AKDT")
    })
  })

  test("time zones Intl can't abbreviate are parsed by our heuristic", () => {
    const dateToStringStub = () => "Sat Dec 02 2023 17:20:26 GMT-0600 (Central Standard Time)"
    const dateToLocaleStringStub = (_, options) => {
      if (options.timeZoneName === "long") {
        return "Thu Nov 30 2023 14:22:57 GMT+0700 (Central Twilight Time)" // not a known edge-case
      } else if (options.timeZoneName === "short") {
        return "11/30/2023, 2:22:57 PM GMT+7" // not possible to abbreviate
      }
    }

    stubDateToString(dateToStringStub, () => stubDateToLocaleString(dateToLocaleStringStub, () => {
      const el = addTimeEl({ format: "%Z", datetime: "2023-11-30T14:22:57Z" })
      LocalTime.process(el)

      assert.equal(getText(el), "CST")
    }))
  })

  test("time zones Intl can't abbreviate and our heuristic can't parse display GMT offset", () => {
    const dateToStringStub = () => ""
    const dateToLocaleStringStub = (_, options) => {
      if (options.timeZoneName === "long") {
        return "Thu Nov 30 2023 14:22:57 GMT+0700 (Central Twilight Time)" // not a known edge-case
      } else if (options.timeZoneName === "short") {
        return "11/30/2023, 2:22:57 PM GMT+7" // not possible to abbreviate
      }
    }

    stubDateToString(dateToStringStub, () => stubDateToLocaleString(dateToLocaleStringStub, () => {
      const el = addTimeEl({ format: "%Z", datetime: "2023-11-30T14:22:57Z" })
      LocalTime.process(el)

      assert.equal(getText(el), "GMT+7")
    }))
  })
})
