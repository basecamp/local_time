{config} = LocalTime
{i18n} = config

dayKeys = "sunday monday tuesday wednesday thursday friday saturday".split(" ")
monthKeys = "january february march april may june july august september october november december".split(" ")

LocalTime.getI18nValue = (keyPath = "", {locale} = locale: config.locale) ->
  value = i18n[locale]
  value = value[key] for key in keyPath.split(".")
  value

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
