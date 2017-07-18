module "page events"

test "document DOMContentLoaded", ->
  el = addTimeEl()
  triggerEvent "DOMContentLoaded"
  ok getText el

test "document time:elapse", ->
  el = addTimeEl()
  triggerEvent "time:elapse"
  ok getText el

test "document page:update with Turbolinks on", ->
  el = addTimeEl()
  triggerEvent "page:update"
  triggerEvent "turbolinks:load"
  ok not getText el

  original = window.Turbolinks
  window.Turbolinks = { supported: true }

  triggerEvent "DOMContentLoaded"

  el2 = addTimeEl()
  triggerEvent "page:update"
  ok getText el2

  # Turbolinks 5
  el3 = addTimeEl()
  triggerEvent "turbolinks:load"
  ok getText el3

  window.Turbolinks = original