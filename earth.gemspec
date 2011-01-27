# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "earth/version"

Gem::Specification.new do |s|
  s.name        = "earth"
  s.version     = Earth::VERSION
  s.date = %q{2011-01-25}
  s.platform    = Gem::Platform::RUBY
  s.authors = ["Seamus Abshere", "Derek Kastner", "Andy Rossmeissl"]
  s.email       = ["dkastner@gmail.com"]
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
  
  s.homepage = %q{http://github.com/brighterplanet/earth}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Land, sky, and sea}

  s.add_runtime_dependency('activerecord', '~> 3')
  s.add_runtime_dependency('data_miner', '~> 1.1.0')
  s.add_runtime_dependency('falls_back_on', '>= 0.0.3')
  s.add_runtime_dependency('geokit', '>= 1.5.0')
  s.add_runtime_dependency('cohort_scope', '>= 0.0.7')
  s.add_runtime_dependency('conversions', '>= 1.4.5')
  s.add_runtime_dependency('weighted_average', '>= 0.0.4')
  s.add_runtime_dependency('loose_tight_dictionary', '>= 0.0.8')
  s.add_development_dependency('sniff', '~> 0.5.0')
  s.add_development_dependency('bueller')
  if RUBY_VERSION >= '1.9'
    s.add_development_dependency 'ruby-debug19'
  else
    s.add_development_dependency 'ruby-debug'
  end
end
