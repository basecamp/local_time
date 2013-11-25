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

    pid = spawn "rackup test/javascripts/config.ru"
    sleep 2

    pass = true
    %w( US/Eastern Pacific/Auckland UTC ).each do |tz|
      unless system "TZ=#{tz} phantomjs vendor/run-qunit.coffee http://localhost:9292"
        pass = false
      end
    end
    Process.kill "INT", pid
    Process.waitpid pid
    exit pass ? 0 : 1
  end
end
