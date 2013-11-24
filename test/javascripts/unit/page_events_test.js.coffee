module "page events"

test "document DOMContentLoaded", ->
  el = addTimeEl()
  triggerEvent "DOMContentLoaded"
  ok el.innerText

test "document time:elapse", ->
  el = addTimeEl()
  triggerEvent "time:elapse"
  ok el.innerText

test "window popstate", ->
  el = addTimeEl()
  triggerEvent "popstate", window
  ok el.innerText

test "document page:update with Turbolinks on", ->
  el = addTimeEl()
  triggerEvent "page:update"
  ok not el.innerText

  original = window.Turbolinks
  window.Turbolinks = { supported: true }

  triggerEvent "DOMContentLoaded"
  triggerEvent "page:update"
  ok el.innerText

  window.Turbolinks = original
