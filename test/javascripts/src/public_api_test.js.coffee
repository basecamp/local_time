module "public API"

for name, method of @LocalTime when name isnt "strftime" and name isnt "i18n"
  do (name, method) ->
    test "##{name}", ->
      ok method(new Date())

{strftime} = @LocalTime

test "#strftime", =>
  ok strftime(new Date(), "%Y")
