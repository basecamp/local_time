require 'rake/testtask'

task default: :test

task test: ['test:helpers', 'test:javascripts']

namespace :test do
  Rake::TestTask.new(:helpers) do |t|
    t.pattern = "test/helpers/*test.rb"
  end

  task :javascripts do
    puts
    puts "# Running JavaScript tests:"
    puts

    pid = spawn "rackup -D test/javascripts/config.ru"
    sleep 2
    result = system "phantomjs vendor/run-qunit.coffee http://localhost:9292"
    Process.kill "INT", pid
    exit result ? 0 : 1
  end
end
