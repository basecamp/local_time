// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
import LocalTime from "local_time";

const {addTimeEl, assert, defer, getText, setText, test, testAsync, testGroup, triggerEvent} = LocalTime.TestHelpers;

testGroup("relative date", function() {
  testAsync("this year", function(done) {
    const now = moment();
    const el = addTimeEl({type: "date", datetime: now.toISOString()});
    return defer(function() {
      assert.equal(getText(el), now.format("MMM D"));
      return done();
    });
  });

  return testAsync("last year", function(done) {
    const before = moment().subtract("years", 1).subtract("days", 1);
    const el = addTimeEl({type: "date", datetime: before.toISOString()});
    return defer(function() {
      assert.equal(getText(el), before.format("MMM D, YYYY"));
      return done();
    });
  });
});

testGroup("relative time or date", function() {
  testAsync("today", function(done) {
    const now = moment();
    const el = addTimeEl({type: "time-or-date", datetime: now.toISOString()});
    return defer(function() {
      assert.equal(getText(el), now.format("h:mma"));
      return done();
    });
  });

  return testAsync("before today", function(done) {
    const before = moment().subtract("days", 1);
    const el = addTimeEl({type: "time-or-date", datetime: before.toISOString()});
    return defer(function() {
      assert.equal(getText(el), before.format("MMM D"));
      return done();
    });
  });
});

testGroup("relative weekday", function() {
  testAsync("today", function(done) {
    const now = moment();
    const el = addTimeEl({type: "weekday", datetime: now.toISOString()});
    return defer(function() {
      assert.equal(getText(el), "today");
      return done();
    });
  });

  testAsync("yesterday", function(done) {
    const yesterday = moment().subtract("days", 1);
    const el = addTimeEl({type: "weekday", datetime: yesterday.toISOString()});
    return defer(function() {
      assert.equal(getText(el), "yesterday");
      return done();
    });
  });

  testAsync("this week", function(done) {
    const recent = moment().subtract("days", 3);
    const el = addTimeEl({type: "weekday", datetime: recent.toISOString()});
    return defer(function() {
      assert.equal(getText(el), recent.format("dddd"));
      return done();
    });
  });

  return testAsync("before this week", function(done) {
    const before = moment().subtract("days", 8);
    const el = addTimeEl({type: "weekday", datetime: before.toISOString()});
    return defer(function() {
      assert.equal(getText(el), "");
      return done();
    });
  });
});

testGroup("relative weekday or date", function() {
  testAsync("today", function(done) {
    const now = moment();
    const el = addTimeEl({type: "weekday-or-date", datetime: now.toISOString()});
    return defer(function() {
      assert.equal(getText(el), "today");
      return done();
    });
  });

  testAsync("yesterday", function(done) {
    const yesterday = moment().subtract("days", 1);
    const el = addTimeEl({type: "weekday-or-date", datetime: yesterday.toISOString()});
    return defer(function() {
      assert.equal(getText(el), "yesterday");
      return done();
    });
  });

  testAsync("this week", function(done) {
    const recent = moment().subtract("days", 3);
    const el = addTimeEl({type: "weekday-or-date", datetime: recent.toISOString()});
    return defer(function() {
      assert.equal(getText(el), recent.format("dddd"));
      return done();
    });
  });

  return testAsync("before this week", function(done) {
    const before = moment().subtract("days", 8);
    const el = addTimeEl({type: "weekday-or-date", datetime: before.toISOString()});
    return defer(function() {
      assert.equal(getText(el), before.format("MMM D"));
      return done();
    });
  });
});
