# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "earth/version"

Gem::Specification.new do |s|
  s.name        = "earth"
  s.version     = Earth::VERSION
  s.date = %q{2011-01-24}
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
  
  s.add_dependency 'activerecord'
  s.add_dependency 'data_miner' unless ENV['LOCAL_DATA_MINER']
  s.add_dependency 'errata'
  s.add_dependency 'falls_back_on'
  s.add_dependency 'geokit'
  s.add_dependency 'cohort_scope'
  s.add_dependency 'conversions'
  s.add_dependency 'weighted_average'
  s.add_dependency 'loose_tight_dictionary'
  s.homepage = %q{http://github.com/brighterplanet/earth}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Land, sky, and sea}

  s.add_development_dependency 'sniff'
  if RUBY_VERSION >= '1.9'
    s.add_development_dependency 'ruby-debug19'
  else
    s.add_development_dependency 'ruby-debug'
  end
end
