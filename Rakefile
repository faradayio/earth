require 'bundler'
Bundler.setup
Bundler::GemHelper.install_tasks

require 'bueller'
Bueller::Tasks.new

task :console do
  Earth.init :all

  require 'irb'
  ARGV.clear
  IRB.start
end

require 'cucumber'
require 'cucumber/rake/task'
desc 'Run all cucumber tests'
Cucumber::Rake::Task.new(:features) do |t|
  if ENV['CUCUMBER_FORMAT']
    t.cucumber_opts = "features --format #{ENV['CUCUMBER_FORMAT']}"
  else
    t.cucumber_opts = 'features --format pretty'
  end
end

desc "Run cucumber tests with RCov"
Cucumber::Rake::Task.new(:features_with_coverage) do |t|
  t.cucumber_opts = "features --format pretty"
  t.rcov = true
  t.rcov_opts = ['--exclude', 'features']
end

require 'rspec/core/rake_task'
desc "Run all examples"
RSpec::Core::RakeTask.new(:examples) do |c|
  if ENV['RSPEC_FORMAT']
    c.rspec_opts = "-Ispec --format #{ENV['RSPEC_FORMAT']}"
  else
    c.rspec_opts = '-Ispec'
  end
end

desc "Run specs with RCov"
RSpec::Core::RakeTask.new(:examples_with_coverage) do |t|
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
  t.rspec_opts = '-Ispec'
end

task :test => [:features, :examples]
task :default => :test

require 'rake/rdoctask'
require 'earth/version'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "earth #{Earth::VERSION}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
