Gem::Specification.new do |s|
  s.name        = "local_time"
  s.version     = "1.0.4"
  s.author      = ["Javan Makhmali", "Sam Stephenson"]
  s.email       = "javan@basecamp.com"
  s.summary     = "Rails engine for cache-friendly, client-side local time"
  s.license     = "MIT"

  s.files = Dir["{app,lib}/**/*", "MIT-LICENSE", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "coffee-rails"

  s.add_development_dependency "rails"
  s.add_development_dependency "rails-dom-testing"
  s.add_development_dependency "blade", "0.4.1"
  s.add_development_dependency "blade-sauce_labs_plugin", "0.4.1"
end
