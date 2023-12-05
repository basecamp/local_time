/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
import LocalTime from "../local_time";

const {config} = LocalTime;
const {i18n} = config;

LocalTime.getI18nValue = function(keyPath, param) {
  if (keyPath == null) { keyPath = ""; }
  if (param == null) { param = {locale: config.locale}; }
  const {locale} = param;
  const value = getValue(i18n[locale], keyPath);
  if (value != null) {
    return value;
  } else if (locale !== config.defaultLocale) {
    return LocalTime.getI18nValue(keyPath, {locale: config.defaultLocale});
  }
};

LocalTime.translate = function(keyPath, interpolations, options) {
  if (interpolations == null) { interpolations = {}; }
  let string = LocalTime.getI18nValue(keyPath, options);
  for (var key in interpolations) {
    var replacement = interpolations[key];
    string = string.replace(`{${key}}`, replacement);
  }
  return string;
};

var getValue = function(object, keyPath) {
  let value = object;
  for (var key of Array.from(keyPath.split("."))) {
    if (value[key] != null) {
      value = value[key];
    } else {
      return null;
    }
  }
  return value;
};
