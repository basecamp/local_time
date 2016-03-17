{config} = LocalTime
{i18n} = config

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

getValue = (object, keyPath) ->
  value = object
  for key in keyPath.split(".")
    if value[key]?
      value = value[key]
    else
      return null
  value
