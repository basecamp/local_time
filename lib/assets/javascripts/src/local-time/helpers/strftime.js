/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS103: Rewrite code to no longer use __guard__, or convert again using --optional-chaining
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
let strftime;
import LocalTime from "../local_time";

const {getI18nValue, translate} = LocalTime;

const supportsIntlDateFormat = typeof (typeof Intl !== 'undefined' && Intl !== null ? Intl.DateTimeFormat : undefined) === "function";

const knownEdgeCaseTimeZones = {
  "Central European Standard Time": "CET",
  "Central European Summer Time": "CEST",
  "China Standard Time": "CST",
  "Israel Daylight Time": "IDT",
  "Israel Standard Time": "IST",
  "Moscow Standard Time": "MSK",
  "Philippine Standard Time": "PHT",
  "Singapore Standard Time": "SGT",
  "Western Indonesia Time": "WIB"
};

LocalTime.knownEdgeCaseTimeZones = knownEdgeCaseTimeZones;

LocalTime.strftime = (strftime = function(time, formatString) {
  const day    = time.getDay();
  const date   = time.getDate();
  const month  = time.getMonth();
  const year   = time.getFullYear();
  const hour   = time.getHours();
  const minute = time.getMinutes();
  const second = time.getSeconds();

  return formatString.replace(/%(-?)([%aAbBcdeHIlmMpPSwyYZ])/g, function(match, flag, modifier) {
    switch (modifier) {
      case "%": return "%";
      case "a": return getI18nValue("date.abbrDayNames")[day];
      case "A": return getI18nValue("date.dayNames")[day];
      case "b": return getI18nValue("date.abbrMonthNames")[month];
      case "B": return getI18nValue("date.monthNames")[month];
      case "c": return time.toString();
      case "d": return pad(date, flag);
      case "e": return date;
      case "H": return pad(hour, flag);
      case "I": return pad(strftime(time, "%l"), flag);
      case "l": if ((hour === 0) || (hour === 12)) { return 12; } else { return (hour + 12) % 12; }
      case "m": return pad(month + 1, flag);
      case "M": return pad(minute, flag);
      case "p": return translate(`time.${(hour > 11 ? "pm" : "am")}`).toUpperCase();
      case "P": return translate(`time.${(hour > 11 ? "pm" : "am")}`);
      case "S": return pad(second, flag);
      case "w": return day;
      case "y": return pad(year % 100, flag);
      case "Y": return year;
      case "Z": return shortTimeZone(time);
    }
  });
});

var pad = function(num, flag) {
  switch (flag) {
    case "-": return num;
    default: return (`0${num}`).slice(-2);
  }
};

var shortTimeZone = function(time) {
  let gmtOffset, longTimeZoneName, shortTimeZoneName;
  if ((longTimeZoneName = edgeCaseTimeZoneNameFor(time))) {
    return knownEdgeCaseTimeZones[longTimeZoneName];
  } else if ((shortTimeZoneName = shortTimeZoneNameFromIntl(time, { allowGMT: false }))) {
    return shortTimeZoneName;
  } else if ((shortTimeZoneName = shortTimeZoneNameFromHeuristic(time))) {
    return shortTimeZoneName;
  } else if ((gmtOffset = shortTimeZoneNameFromIntl(time, { allowGMT: true }))) {
    return gmtOffset;
  } else {
    return "";
  }
};

var edgeCaseTimeZoneNameFor = time => Object.keys(knownEdgeCaseTimeZones).find(function(name) {
  if (supportsIntlDateFormat) {
    return new Date(time).toLocaleString("en-US", { timeZoneName: "long" }).includes(name);
  } else {
    return time.toString().includes(name);
  }
});

var shortTimeZoneNameFromIntl = function(time, { allowGMT }) {
  if (supportsIntlDateFormat) {
    const shortTimeZoneName = new Date(time).toLocaleString("en-US", { timeZoneName: "short" }).split(" ").pop();
    if (allowGMT || !shortTimeZoneName.includes("GMT")) { return shortTimeZoneName; }
  }
};

var shortTimeZoneNameFromHeuristic = function(time) {
  let name;
  const string = time.toString();
  // Sun Aug 30 2015 10:22:57 GMT-0400 (NAME)
  if (name = __guard__(string.match(/\(([\w\s]+)\)$/), x => x[1])) {
    if (/\s/.test(name)) {
      // Sun Aug 30 2015 10:22:57 GMT-0400 (Eastern Daylight Time)
      return name.match(/\b(\w)/g).join("");
    } else {
      // Sun Aug 30 2015 10:22:57 GMT-0400 (EDT)
      return name;
    }
  // Sun Aug 30 10:22:57 EDT 2015
  } else if (name = __guard__(string.match(/(\w{3,4})\s\d{4}$/), x1 => x1[1])) {
    return name;
  // "Sun Aug 30 10:22:57 UTC-0400 2015"
  } else if (name = __guard__(string.match(/(UTC[\+\-]\d+)/), x2 => x2[1])) {
    return name;
  }
};

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}