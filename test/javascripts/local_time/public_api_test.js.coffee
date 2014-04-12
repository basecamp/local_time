module "public API"

for name, method of @LocalTime when name isnt "strftime"
  do (name, method) ->
    test "##{name}", ->
      ok method(new Date())

{strftime} = @LocalTime

test "#strftime", =>
  ok strftime(new Date(), "%Y")
