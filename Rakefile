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
    system "yarn start"
  end
end

namespace :assets do
  desc "Compile assets"
  task :compile do
    puts "[compile] JS assets"
    system "yarn build"
  end

  desc "Verify compiled assets"
  task :verify do
    verify_file "app/assets/javascripts/local-time.es2017-umd.js"
    verify_file "test/javascripts/builds/index.js"
    verify_requireable
  end
end

def verify_file(file)
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
end

def verify_requireable
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
