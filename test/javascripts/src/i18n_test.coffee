{addTimeEl, assert, defer, getText, setText, test, testAsync, testGroup, triggerEvent} = LocalTime.TestHelpers
{config} = LocalTime
{i18n} = config

testGroup "i18n", ->
  testAsync "updating a value", (done) ->
    now = moment()
    values = i18n[config.defaultLocale].date

    originalValue = values.today
    values.today = "2day"

    el = addTimeEl type: "weekday", datetime: now.toISOString()
    defer ->
      assert.equal getText(el), "2day"
      assert.equal getText(el), "2day"
      values.today = originalValue
      done()

  testAsync "adding a new locale", (done) ->
    now = moment()

    originalLocale = config.locale
    config.locale = "es"
    i18n.es = date: today: "hoy"

    el = addTimeEl type: "weekday", datetime: now.toISOString()
    defer ->
      assert.equal getText(el), "hoy"
      config.locale = originalLocale
      done()

  testAsync "falling back to the default locale", (done) ->
    now = moment()
    yesterday = moment().subtract("days", 1)

    originalLocale = config.locale
    config.locale = "es"
    i18n.es = date: yesterday: "ayer"

    elWithTranslation = addTimeEl type: "weekday", datetime: yesterday.toISOString()
    elWithoutTranslation = addTimeEl type: "weekday", datetime: now.toISOString()
    defer ->
      assert.equal getText(elWithTranslation), "ayer"
      assert.equal getText(elWithoutTranslation), "today"
      config.locale = originalLocale
      done()
