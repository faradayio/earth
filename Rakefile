require 'bundler'
Bundler.setup
Bundler::GemHelper.install_tasks

require 'bueller'
Bueller::Tasks.new

task :console do
  require 'earth'
  logger = Logger.new('log/test.log')
  DataMiner.logger = ActiveRecord::Base.logger = logger
  ActiveRecord::Base.establish_connection :adapter => 'postgresql', :database => 'test_earth'
  Earth.init :all

  require 'irb'
  ARGV.clear
  IRB.start
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

if RUBY_VERSION =~ /^1\.8/
  desc "Run specs with RCov"
  RSpec::Core::RakeTask.new(:examples_with_coverage) do |t|
    t.rcov = true
    t.rcov_opts = ['--exclude', 'spec']
    t.rspec_opts = '-Ispec'
  end
end

task :test => :examples
task :default => :test

require 'earth/version'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "earth #{Earth::VERSION}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
