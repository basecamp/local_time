// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
import LocalTime from "local_time";

const {addTimeEl, assert, defer, getText, setText, test, testAsync, testGroup, triggerEvent} = LocalTime.TestHelpers;

testGroup("localized", function() {
  for (var id of ["one", "two", "past", "future"]) {
    test(id, () => assertLocalized(id));
  }

  test("date", () => assertLocalized("date", "date"));

  return test("unparseable time", function() {
    const el = addTimeEl({format: "%Y", datetime: ":("});
    setText(el, "2013");
    return assert.equal(getText(el), "2013");
  });
});

test "processed timestamp", ->
  el = addTimeEl type: "time-or-date", datetime: moment().toISOString()
  assert.notOk el.getAttribute("data-processed-at")
  LocalTime.run()
  assert.ok el.getAttribute("data-processed-at")

var assertLocalized = function(id, type) {
  let compare, datetime, local, momentFormat;
  if (type == null) { type = "time"; }
  switch (type) {
    case "time":
      momentFormat = "MMMM D, YYYY h:mma";
      compare = "toString";
      break;
    case "date":
      momentFormat = "MMMM D, YYYY";
      compare = "dayOfYear";
      break;
  }

  const el = document.getElementById(id);

  assert.ok(datetime = el.getAttribute("datetime"));
  assert.ok(local = getText(el));

  const datetimeParsed = moment(datetime);
  const localParsed = moment(local, momentFormat);

  assert.ok(datetimeParsed.isValid());
  assert.ok(localParsed.isValid());
  return assert.equal(datetimeParsed[compare](), localParsed[compare]());
};
