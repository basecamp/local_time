{config} = LocalTime
{i18n} = config

module "i18n"

test "updating a value", (assert) ->
  done = assert.async()
  now = moment()
  values = i18n[config.defaultLocale]

  originalValue = values.today
  values.today = "2day"

  el = addTimeEl type: "weekday", datetime: now.toISOString()
  defer ->
    equal getText(el), "2day"
    values.today = originalValue
    done()

test "adding a new locale", (assert) ->
  done = assert.async()
  now = moment()

  originalLocale = config.locale
  config.locale = "es"
  i18n.es = today: "hoy"

  el = addTimeEl type: "weekday", datetime: now.toISOString()
  defer ->
    equal getText(el), "hoy"
    config.locale = originalLocale
    done()

test "falling back to the default locale", (assert) ->
  done = assert.async()
  now = moment()
  yesterday = moment().subtract("days", 1)

  originalLocale = config.locale
  config.locale = "es"
  i18n.es = yesterday: "ayer"

  elWithTranslation = addTimeEl type: "weekday", datetime: yesterday.toISOString()
  elWithoutTranslation = addTimeEl type: "weekday", datetime: now.toISOString()
  defer ->
    equal getText(elWithTranslation), "ayer"
    equal getText(elWithoutTranslation), "today"
    config.locale = originalLocale
    done()
