Gem::Specification.new do |s|
  s.name        = "local_time"
  s.version     = "1.0.0"
  s.author      = "Javan Makhmali"
  s.email       = "javan@37signals.com"
  s.summary     = "Convert UTC <time> tags to the browser's local time using JavaScript"
  s.license     = "MIT"

  s.files = Dir["{app,lib}/**/*", "MIT-LICENSE", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "coffee-rails"
end
