/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
import LocalTime from "../local_time";

// Older browsers do not support ISO8601 (JSON) timestamps in Date.parse
const supportsISO8601 = !isNaN(Date.parse("2011-01-01T12:00:00-05:00"));

LocalTime.parseDate = function(dateString) {
  dateString = dateString.toString();
  if (!supportsISO8601) { dateString = reformatDateString(dateString); }
  return new Date(Date.parse(dateString));
};

const iso8601Pattern = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(Z|[-+]?[\d:]+)$/;

var reformatDateString = function(dateString) {
  let matches;
  if (matches = dateString.match(iso8601Pattern)) {
    let offset;
    const [_, year, month, day, hour, minute, second, zone] = Array.from(matches);
    if (zone !== "Z") { offset = zone.replace(":", ""); }
    return `${year}/${month}/${day} ${hour}:${minute}:${second} GMT${[offset]}`;
  }
};
