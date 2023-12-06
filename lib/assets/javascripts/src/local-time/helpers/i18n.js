import LocalTime from "../local_time"

const { config } = LocalTime
const { i18n } = config

LocalTime.getI18nValue = (keyPath = "", param = { locale: config.locale }) => {
  const { locale } = param
  const value = getValue(i18n[locale], keyPath)
  if (value) {
    return value
  } else if (locale !== config.defaultLocale) {
    return LocalTime.getI18nValue(keyPath, { locale: config.defaultLocale })
  }
}

LocalTime.translate = (keyPath, interpolations = {}, options) => {
  let string = LocalTime.getI18nValue(keyPath, options)
  for (const key in interpolations) {
    const replacement = interpolations[key]
    string = string.replace(`{${key}}`, replacement)
  }
  return string
}

function getValue(object, keyPath) {
  let value = object
  for (var key of Array.from(keyPath.split("."))) {
    if (value[key]) {
      value = value[key]
    } else {
      return null
    }
  }
  return value
}
