require 'rake/testtask'

task default: :test

task test: ['test:helpers', 'test:javascripts']

namespace :test do
  Rake::TestTask.new(:helpers) do |t|
    t.pattern = "test/helpers/*test.rb"
  end

  task :javascripts do
    puts "\n# Running JavaScript tests:\n\n"

    pass    = true
    command = "phantomjs vendor/run-qunit.coffee http://localhost:9292"
    zones   = %w( US/Eastern Pacific/Auckland UTC )

    with_js_server do
      zones.each do |tz|
        pass = false unless system "TZ=#{tz} #{command}"
      end
    end

    exit pass ? 0 : 1
  end
end

def with_js_server
  begin
    pid = spawn "rackup test/javascripts/config.ru"
    sleep 2
    yield
  ensure
    Process.kill "INT", pid
    Process.waitpid pid
  end
end
