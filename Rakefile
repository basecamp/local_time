require 'rake/testtask'

task default: :test

task test: ['test:helpers', 'test:javascripts']

namespace :test do
  Rake::TestTask.new(:helpers) do |t|
    t.pattern = "test/helpers/*test.rb"
  end

  task :javascripts do
    abort unless system "bin/blade ci"
  end
end
