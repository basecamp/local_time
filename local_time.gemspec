require_relative "lib/local_time/version"

Gem::Specification.new do |s|
  s.name = "local_time"
  s.version = LocalTime::VERSION
  s.author = [ "Javan Makhmali", "Sam Stephenson" ]
  s.email = "javan@basecamp.com"
  s.summary = "Rails engine for cache-friendly, client-side local time"
  s.homepage = "https://github.com/basecamp/local_time"
  s.license = "MIT"

  s.files = Dir["app/**/*", "lib/local_time.rb", "lib/local_time/**/*", "MIT-LICENSE", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency "rake", "~> 13.0"
  s.add_development_dependency "rails", "~> 7.0"
  s.add_development_dependency "rails-dom-testing", "~> 2.0"
end
