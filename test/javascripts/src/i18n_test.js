/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
import LocalTime from "local_time";

const {addTimeEl, assert, defer, getText, setText, test, testAsync, testGroup, triggerEvent} = LocalTime.TestHelpers;
const {config} = LocalTime;
const {i18n} = config;

testGroup("i18n", function() {
  testAsync("updating a value", function(done) {
    const now = moment();
    const values = i18n[config.defaultLocale].date;

    const originalValue = values.today;
    values.today = "2day";

    const el = addTimeEl({type: "weekday", datetime: now.toISOString()});
    return defer(function() {
      assert.equal(getText(el), "2day");
      assert.equal(getText(el), "2day");
      values.today = originalValue;
      return done();
    });
  });

  testAsync("adding a new locale", function(done) {
    const now = moment();

    const originalLocale = config.locale;
    config.locale = "es";
    i18n.es = {date: {today: "hoy"}};

    const el = addTimeEl({type: "weekday", datetime: now.toISOString()});
    return defer(function() {
      assert.equal(getText(el), "hoy");
      config.locale = originalLocale;
      return done();
    });
  });

  return testAsync("falling back to the default locale", function(done) {
    const now = moment();
    const yesterday = moment().subtract("days", 1);

    const originalLocale = config.locale;
    config.locale = "es";
    i18n.es = {date: {yesterday: "ayer"}};

    const elWithTranslation = addTimeEl({type: "weekday", datetime: yesterday.toISOString()});
    const elWithoutTranslation = addTimeEl({type: "weekday", datetime: now.toISOString()});
    return defer(function() {
      assert.equal(getText(elWithTranslation), "ayer");
      assert.equal(getText(elWithoutTranslation), "today");
      config.locale = originalLocale;
      return done();
    });
  });
});
