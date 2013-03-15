# -*- encoding: utf-8 -*-
require File.expand_path("../lib/earth/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "earth"
  s.version     = Earth::VERSION
  s.authors = ["Seamus Abshere", "Derek Kastner", "Andy Rossmeissl", "Ian Hough"]
  s.email = ['seamus@abshere.net', 'dkastner@gmail.com', 'andy@rossmeissl.net', 'ijhough@gmail.com']
  s.homepage    = "https://github.com/brighterplanet/earth"
  s.summary     = %Q{Land, sky, and sea}
  s.description = %Q{An earth-simulation environment with ActiveRecord models and data}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.require_paths = ["lib"]
  
  s.add_runtime_dependency 'activerecord'
  s.add_runtime_dependency 'activesupport'
  s.add_runtime_dependency 'cohort_analysis'
  s.add_runtime_dependency 'conversions'
  s.add_runtime_dependency 'data_miner', '>=2.4.0'
  s.add_runtime_dependency 'falls_back_on'
  s.add_runtime_dependency 'fixed_width-multibyte'
  s.add_runtime_dependency 'fuzzy_match', '>=1.3.3'
  s.add_runtime_dependency 'remote_table', '>=2.1.0'
  s.add_runtime_dependency 'table_warnings', '>=1.0.1'
  s.add_runtime_dependency 'to_regexp'
  s.add_runtime_dependency 'weighted_average', '>=1.0.2'
  s.add_runtime_dependency 'timeframe'
  s.add_runtime_dependency 'geocoder'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'charisma'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'dbf'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'georuby'
  s.add_development_dependency 'mysql2' # for bin/earth_tester.rb; use mysql2 for utf-8 compatibility
  s.add_development_dependency 'pg'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'sandbox'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'thor'
  s.add_development_dependency 'pry'
end
