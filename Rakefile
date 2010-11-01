require 'rubygems'
require 'rake/rdoctask'
require 'jeweler'
if ENV['BUNDLE'] == 'true'
  begin
    require 'bundler'
    Bundler.setup
  rescue LoadError
    puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
  end
end

Jeweler::Tasks.new do |gem|
  gem.name = "earth"
  gem.summary = %Q{Land, sky, and sea}
  gem.description = %Q{An earth-simulation environment with ActiveRecord models and data}
  gem.email = 'andy@rossmeissl.net'
  gem.homepage = 'http://github.com/brighterplanet/earth'
  gem.authors = ['Seamus Abshere', 'Derek Kastner', "Andy Rossmeissl"]
  gem.files = ['LICENSE', 'README.markdown'] + 
    Dir.glob(File.join('lib', '**','*.rb')) +
    Dir.glob(File.join('vendor', '**','*')) - 
    ['.gitignore','Gemfile','Gemfile.lock']
  gem.test_files = Dir.glob(File.join('features', '**', '*.rb')) +
    Dir.glob(File.join('spec', '**', '*.rb')) +
    Dir.glob(File.join('lib', 'test_support', '**/*.rb')) +
    ['Gemfile','Gemfile.lock']
  gem.add_dependency 'activerecord', '>=3.0.0.beta4'
  gem.add_dependency 'data_miner', '~>0.5.6' unless ENV['LOCAL_DATA_MINER']
  gem.add_dependency 'falls_back_on', '>=0.0.3'
  gem.add_dependency 'geokit', '>=1.5.0'
  gem.add_dependency 'cohort_scope', '>=0.0.7'
  gem.add_dependency 'conversions', '>=1.4.5'
  gem.add_dependency 'weighted_average', '>=0.0.4'
  gem.add_dependency 'loose_tight_dictionary', '>=0.0.8'
  gem.add_development_dependency 'rspec', '>=2.0.0.beta.17'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'jeweler'
  gem.add_development_dependency 'rcov'
  gem.add_development_dependency 'rdoc'
  gem.add_development_dependency 'sqlite3-ruby', '>=1.3.0'
end
Jeweler::GemcutterTasks.new

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

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "earth #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
