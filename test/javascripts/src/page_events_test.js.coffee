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
  ok not getText el

  original = window.Turbolinks
  window.Turbolinks = { supported: true }

  triggerEvent "DOMContentLoaded"
  triggerEvent "page:update"
  ok getText el

  window.Turbolinks = original
