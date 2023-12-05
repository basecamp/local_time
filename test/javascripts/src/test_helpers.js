// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
import LocalTime from "local_time";

LocalTime.start();

LocalTime.TestHelpers = {
  assert: QUnit.assert,
  testGroup: QUnit.module,
  test: QUnit.test,

  testAsync(name, callback) {
    return QUnit.test(name, function(assert) {
      const done = assert.async();
      return callback(done);
    });
  },

  addTimeEl(param) {
    if (param == null) { param = {}; }
    let {format, type, datetime, format24} = param;
    if (format == null) { format = "%Y"; }
    if (type == null) { type = "time"; }
    if (datetime == null) { datetime = "2013-11-12T12:13:00Z"; }

    const el = document.createElement("time");
    el.setAttribute("data-local", type);
    el.setAttribute("data-format", format);
    el.setAttribute("datetime", datetime);
    if (format24) { el.setAttribute("data-format24", format24); }

    document.body.appendChild(el);
    return el;
  },

  setText(el, text) {
    return el.textContent = text;
  },

  getText(el) {
    // innerHTML works in all browsers so using it ensures we're
    // reading the text content, not a potentially arbitrary property.
    return el.innerHTML;
  },

  getTitle(el) {
    return el.getAttribute("title");
  },

  triggerEvent(name, el) {
    if (el == null) { el = document; }
    const event = document.createEvent("Events");
    event.initEvent(name, true, true);
    return el.dispatchEvent(event);
  },

  defer(callback) {
    return setTimeout(callback, 1);
  }
};
