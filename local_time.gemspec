Gem::Specification.new do |s|
  s.name        = "local_time"
  s.version     = "0.1.0"
  s.author      = ["Javan Makhmali", "Sam Stephenson"]
  s.email       = "javan@37signals.com"
  s.summary     = "Rails engine for displaying local times using JavaScript"
  s.license     = "MIT"

  s.files = Dir["{app,lib}/**/*", "MIT-LICENSE", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "coffee-rails"
end
