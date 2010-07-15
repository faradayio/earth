require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "earth"
    gem.summary = %Q{Land, sky, and sea}
    gem.description = %Q{An earth-simulation environment with ActiveRecord models and data}
    gem.email = 'andy@rossmeissl.net'
    gem.homepage = 'http://github.com/brighterplanet/earth'
    gem.authors = ['Seamus Abshere', 'Derek Kastner', "Andy Rossmeissl"]
    gem.add_dependency 'activerecord', '>= 3.0.0.beta4'
    gem.add_dependency 'data_miner', '= 0.4.45'
    gem.add_dependency 'falls_back_on', '= 0.0.2'
    gem.add_dependency 'geokit', '= 1.5.0'
    gem.add_development_dependency 'rspec', '= 2.0.0.beta.17'
    gem.add_development_dependency 'rake'
    gem.add_development_dependency 'jeweler'
    gem.add_development_dependency 'rcov'
    gem.add_development_dependency 'rdoc'
    gem.add_development_dependency 'sqlite3-ruby', '1.3.0'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "earth #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
