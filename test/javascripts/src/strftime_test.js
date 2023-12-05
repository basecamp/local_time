// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS103: Rewrite code to no longer use __guard__, or convert again using --optional-chaining
 * DS205: Consider reworking code to avoid use of IIFEs
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
import LocalTime from "local_time";

const {addTimeEl, assert, defer, getText, setText, test, testAsync, testGroup, triggerEvent} = LocalTime.TestHelpers;

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
};

const stubDateToLocaleString = function(stubImplementation, callback) {
  const original = Date.prototype.toLocaleString;
  Date.prototype.toLocaleString = stubImplementation;
  try {
    return callback();
  } finally {
    Date.prototype.toLocaleString = original;
  }
};

const stubDateToString = function(stubImplementation, callback) {
  const original = Date.prototype.toString;
  Date.prototype.toString = stubImplementation;
  try {
    return callback();
  } finally {
    Date.prototype.toString = original;
  }
};

testGroup("strftime", () => (() => {
  const result = [];
  for (let day = 0; day <= 30; day += 6) {
    result.push(((day => (() => {
      const result1 = [];
      for (let hour = 0; hour <= 24; hour += 6) {
        result1.push((function(hour) {

          let format;
          for (format in momentMap) {
            var momentFormat = momentMap[format];
            (((format, momentFormat) => test(`${format} (+${day} days, ${hour} hours)`, function() {
              let func;
              const now = moment().add("days", day).add("hours", hour);
              const el  = addTimeEl({format, datetime: now.toISOString()});
              LocalTime.process(el);

              return assert.equal(getText(el),
                (func = __guard__(momentFormat.match(/(\w+)\(\)/), x => x[1])) ?
                  now.toDate()[func]()
                :
                  now.format(momentFormat)
              );
            })))(format, momentFormat);
          }

          return test(`%Z Timezone (+${day} days, ${hour} hours)`, function() {
            const now = moment().add("days", day).add("hours", hour);
            const el  = addTimeEl({format: "%Z", datetime: now.toISOString()});
            LocalTime.process(el);

            const text = getText(el);
            return assert.ok(/^(\w{3,4}|UTC[\+\-]\d+)$/.test(text), `'${text}' doesn't look like a timezone. System date: '${new Date}'`);
          });
        })(hour));
      }
      return result1;
    })()))(day));
  }
  return result;
})());

testGroup("strftime time zones", function() {
  for (var timeZone of Array.from(Object.keys(LocalTime.knownEdgeCaseTimeZones))) {
    ((timeZone => test(`edge-case time zone ${timeZone}`, function() {
      const stub = () => `Thu Nov 30 2023 14:22:57 GMT-0000 (${timeZone})`;

      return stubDateToLocaleString(stub, function() {
        const el = addTimeEl({format: "%Z", datetime: "2023-11-30T14:22:57Z"});
        LocalTime.process(el);

        return assert.equal(getText(el), LocalTime.knownEdgeCaseTimeZones[timeZone]);
    });
  })))(timeZone);
  }

  test("time zones Intl can abbreviate are parsed correctly", function() {
    const stub = function(_, options) {
      if (options.timeZoneName === "long") {
        return "Thu Nov 30 2023 14:22:57 GMT-0800 (Alaska Daylight Time)"; // not a known edge-case
      } else if (options.timeZoneName === "short") {
        return "11/30/2023, 2:22:57 PM AKDT"; // possible to abbreviate
      }
    };

    return stubDateToLocaleString(stub, function() {
      const el = addTimeEl({format: "%Z", datetime: "2023-11-30T14:22:57Z"});
      LocalTime.process(el);

      return assert.equal(getText(el), "AKDT");
    });
  });

  test("time zones Intl can't abbreviate are parsed by our heuristic", function() {
    const dateToStringStub = () => "Sat Dec 02 2023 17:20:26 GMT-0600 (Central Standard Time)";
    const dateToLocaleStringStub = function(_, options) {
      if (options.timeZoneName === "long") {
        return "Thu Nov 30 2023 14:22:57 GMT+0700 (Central Twilight Time)"; // not a known edge-case
      } else if (options.timeZoneName === "short") {
        return "11/30/2023, 2:22:57 PM GMT+7"; // not possible to abbreviate
      }
    };

    return stubDateToString(dateToStringStub, () => stubDateToLocaleString(dateToLocaleStringStub, function() {
      const el = addTimeEl({format: "%Z", datetime: "2023-11-30T14:22:57Z"});
      LocalTime.process(el);

      return assert.equal(getText(el), "CST");
    }));
  });

  return test("time zones Intl can't abbreviate and our heuristic can't parse display GMT offset", function() {
    const dateToStringStub = () => "";
    const dateToLocaleStringStub = function(_, options) {
      if (options.timeZoneName === "long") {
        return "Thu Nov 30 2023 14:22:57 GMT+0700 (Central Twilight Time)"; // not a known edge-case
      } else if (options.timeZoneName === "short") {
        return "11/30/2023, 2:22:57 PM GMT+7"; // not possible to abbreviate
      }
    };

    return stubDateToString(dateToStringStub, () => stubDateToLocaleString(dateToLocaleStringStub, function() {
      const el = addTimeEl({format: "%Z", datetime: "2023-11-30T14:22:57Z"});
      LocalTime.process(el);

      return assert.equal(getText(el), "GMT+7");
    }));
  });
});

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}