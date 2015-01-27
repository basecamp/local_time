require 'sprockets'
require 'coffee-rails'

Root = File.expand_path("../../../..", __FILE__)

Assets = Sprockets::Environment.new(Root) do |env|
  env.append_path "app/assets/javascripts"
  env.append_path "test/javascripts"
end

map "/css" do
  run Assets
end

map "/js" do
  run Assets
end

map("/") { run Rack::File.new("#{Root}/test/javascripts/runner") }
