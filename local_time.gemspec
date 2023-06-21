Gem::Specification.new do |s|
  s.name        = "local_time"
  s.version     = "2.1.0"
  s.author      = [ "Javan Makhmali", "Sam Stephenson" ]
  s.email       = "javan@basecamp.com"
  s.summary     = "Rails engine for cache-friendly, client-side local time"
  s.license     = "MIT"

  s.files = Dir["app/**/*", "lib/local_time.rb", "MIT-LICENSE", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency "rubocop"
  s.add_development_dependency "rubocop-performance"
  s.add_development_dependency "rubocop-rails"
  s.add_development_dependency "rubocop-rake"
end
