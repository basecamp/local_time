{config} = LocalTime
{i18n} = config

dayKeys = "sunday monday tuesday wednesday thursday friday saturday".split(" ")
monthKeys = "january february march april may june july august september october november december".split(" ")

LocalTime.getI18nValue = (keyPath = "", {locale} = locale: config.locale) ->
  value = getValue(i18n[locale], keyPath)
  if value?
    value
  else if locale isnt config.defaultLocale
    LocalTime.getI18nValue(keyPath, locale: config.defaultLocale)

LocalTime.translate = (keyPath, interpolations = {}, options) ->
  string = LocalTime.getI18nValue(keyPath, options)
  for key, replacement of interpolations
    string = string.replace("{#{key}}", replacement)
  string

LocalTime.getDayName = (index) ->
  i18n[config.locale].weekdays ?= (LocalTime.translate(key) for key in dayKeys)
  i18n[config.locale].weekdays[index]

LocalTime.getMonthName = (index) ->
  i18n[config.locale].months ?= (LocalTime.translate(key) for key in monthKeys)
  i18n[config.locale].months[index]


getValue = (object, keyPath) ->
  value = object
  for key in keyPath.split(".")
    if value[key]?
      value = value[key]
    else
      return null
  value
