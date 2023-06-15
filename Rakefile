require "rake/testtask"
require "bundler/gem_tasks"
require "open3"

task default: :test

task test: ["test:helpers", "test:assets", "test:javascripts"]

namespace :test do
  Rake::TestTask.new(:helpers) do |t|
    t.pattern = "test/helpers/*test.rb"
  end

  task assets: ["assets:compile", "assets:verify"]

  task :javascripts do
    abort unless system "bin/blade ci"
  end
end

namespace :assets do
  desc "Verify compiled assets"
  task :verify do
    file = "app/assets/javascripts/local-time.es2017-umd.js"
    pathname = Pathname.new("#{__dir__}/#{file}")

    print "[verify] #{file} exists "
    if pathname.exist?
      puts "[OK]"
    else
      puts "[FAIL]"
      fail
    end

    print "[verify] #{file} is a UMD module "
    if pathname.read =~ /module\.exports.*define\.amd/m
      puts "[OK]"
    else
      $stderr.puts "[FAIL]"
      fail
    end

    print "[verify] #{__dir__} can be required as a module "
    js = <<-JS
      window = {}
      document = { documentElement: {} }
      require("#{__dir__}")
    JS
    _, stderr, status = Open3.capture3("node", "--print", js)
    if status.success?
      puts "[OK]"
    else
      puts "[FAIL]\n#{stderr}"
      fail
    end
  end
end
