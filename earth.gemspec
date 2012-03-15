# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "earth/version"

Gem::Specification.new do |s|
  s.name        = "earth"
  s.version     = Earth::VERSION
  s.date = "2012-03-05"
  s.platform    = Gem::Platform::RUBY
  s.authors = ["Seamus Abshere", "Derek Kastner", "Andy Rossmeissl"]
  s.email = %q{andy@rossmeissl.net}
  s.homepage    = "https://github.com/brighterplanet/earth"
  s.summary     = %Q{Land, sky, and sea}
  s.description = %Q{An earth-simulation environment with ActiveRecord models and data}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = [
    "LICENSE",
     "LICENSE-PREAMBLE",
     "README.markdown"
  ]
  s.require_paths = ["lib"]
  
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  
  s.add_runtime_dependency 'activerecord'
  s.add_runtime_dependency 'activesupport'
  s.add_runtime_dependency 'cohort_analysis'
  s.add_runtime_dependency 'conversions'
  s.add_runtime_dependency 'data_miner', '>=1.3'
  s.add_runtime_dependency 'falls_back_on'
  s.add_runtime_dependency 'fixed_width-multibyte'
  s.add_runtime_dependency 'fuzzy_match', '>=1.1.0'
  s.add_runtime_dependency 'geokit'
  s.add_runtime_dependency 'mini_record-compat' # need https://github.com/DAddYE/mini_record/pull/7
  s.add_runtime_dependency 'remote_table', '>=1.3.0'
  s.add_runtime_dependency 'table_warnings', '>=0.0.6'
  s.add_runtime_dependency 'to_regexp'
  s.add_runtime_dependency 'weighted_average', '>=1.0.2'
  s.add_development_dependency 'bueller'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'charisma'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'mysql2' # for bin/earth_tester.rb; use mysql2 for utf-8 compatibility
  s.add_development_dependency 'pg'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'sqlite3-ruby'
end
