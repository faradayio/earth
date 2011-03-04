# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "earth/version"

Gem::Specification.new do |s|
  s.name        = "earth"
  s.version     = Earth::VERSION
  s.date = "2011-02-25"
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

  s.add_runtime_dependency 'activerecord', '~> 3'
  s.add_runtime_dependency 'cohort_scope', '>= 0.0.7'
  s.add_runtime_dependency 'data_miner', '~> 1.1.1'
  s.add_runtime_dependency 'falls_back_on', '>= 0.0.3'
  s.add_runtime_dependency 'geokit-rails'
  s.add_runtime_dependency 'loose_tight_dictionary', '>= 0.0.8'
  s.add_runtime_dependency 'weighted_average', '>= 0.0.4'
end
