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
<<<<<<< HEAD
=======
  s.test_files = [
     "features/automobile_fuel_type.feature",
     "features/automobile_make_model_year_variant.feature",
     "features/automobile_make_model_year.feature",
     "features/automobile_make_model.feature",
     "features/automobile_make_year.feature",
     "features/automobile_size_class.feature",
     "features/automobile_size_class_year.feature",
     "features/automobile_type_fuel_age.feature",
     "features/automobile_type_fuel_control.feature",
     "features/automobile_type_fuel_year.feature",
     "features/automobile_type_fuel_year_control.feature",
     "features/automobile_type_year.feature",
     "features/shipment_mode.feature",
     "features/egrid_region.feature",
     "features/data_center_company.feature",
     "features/flight_segment.feature",
     "features/support",
     "features/support/imports",
     "features/support/imports/automobile_make_year_bad.csv",
     "features/support/imports/automobile_make_year_good.csv",
     "features/support/imports/automobile_size_class_bad.csv",
     "features/support/imports/automobile_size_class_good.csv",
     "features/support/imports/automobile_size_class_year_bad.csv",
     "features/support/imports/automobile_size_class_year_good.csv",
     "features/support/imports/bus_class_bad.csv",
     "features/support/imports/carrier_mode_bad.csv",
     "features/support/imports/data_center_company_bad.csv",
     "features/support/imports/server_type_good.csv",
     "features/support/imports/automobile_make_model_year_variant_good.csv",
     "features/support/imports/egrid_region_bad.csv",
     "features/support/imports/automobile_make_model_year_bad.csv",
     "features/support/imports/automobile_type_fuel_age_bad.csv",
     "features/support/imports/computation_platform_bad.csv",
     "features/support/imports/automobile_type_fuel_age_good.csv",
     "features/support/imports/automobile_type_fuel_year_bad.csv",
     "features/support/imports/greenhouse_gas_good.csv",
     "features/support/imports/automobile_fuel_type_good.csv",
     "features/support/imports/automobile_type_fuel_year_control_good.csv",
     "features/support/imports/carrier_bad.csv",
     "features/support/imports/automobile_size_class_year_good.csv",
     "features/support/imports/data_center_company_good.csv",
     "features/support/imports/automobile_make_bad.csv",
     "features/support/imports/automobile_type_fuel_year_control_bad.csv",
     "features/support/imports/computation_platform_good.csv",
     "features/support/imports/automobile_make_model_year_variant_bad.csv",
     "features/support/imports/automobile_type_fuel_control_bad.csv",
     "features/support/imports/automobile_size_class_good.csv",
     "features/support/imports/shipment_mode_good.csv",
     "features/support/imports/automobile_type_year_good.csv",
     "features/support/imports/automobile_make_fleet_year_bad.csv",
     "features/support/imports/automobile_fuel_type_bad.csv",
     "features/support/imports/greenhouse_gas_bad.csv",
     "features/support/imports/automobile_make_model_good.csv",
     "features/support/imports/automobile_size_class_year_bad.csv",
     "features/support/imports/automobile_make_model_year_good.csv",
     "features/support/imports/carrier_good.csv",
     "features/support/imports/fuel_year_good.csv",
     "features/support/imports/carrier_mode_good.csv",
     "features/support/imports/automobile_type_fuel_year_good.csv",
     "features/support/imports/egrid_subregion_bad.csv",
     "features/support/imports/server_type_alias_bad.csv",
     "features/support/imports/automobile_make_fleet_year_good.csv",
     "features/support/imports/fuel_year_bad.csv",
     "features/support/imports/bus_class_good.csv",
     "features/support/imports/egrid_region_good.csv",
     "features/support/imports/shipment_mode_bad.csv",
     "features/support/imports/automobile_make_model_bad.csv",
     "features/support/imports/rail_class_bad.csv",
     "features/support/imports/automobile_make_year_good.csv",
     "features/support/imports/automobile_make_good.csv",
     "features/support/imports/automobile_size_class_bad.csv",
     "features/support/imports/flight_segment_good.csv",
     "features/support/imports/flight_segment_bad.csv",
     "features/support/imports/automobile_type_year_bad.csv",
     "features/support/imports/server_type_alias_good.csv",
     "features/support/imports/egrid_subregion_good.csv",
     "features/support/imports/server_type_bad.csv",
     "features/support/imports/automobile_type_fuel_control_good.csv",
     "features/support/imports/rail_class_good.csv",
     "features/support/env.rb",
     "features/automobile_type_fuel_year.feature",
     "features/automobile_make.feature",
     "features/bus_class.feature",
     "features/automobile_type_fuel_control.feature",
     "features/carrier_mode.feature",
     "features/automobile_size_class.feature",
     "features/rail_class.feature",
     "features/automobile_size_class_year.feature",
     "features/computation_platform.feature",
     "features/egrid_subregion.feature",
     "features/greenhouse_gas.feature",
     "features/automobile_type_fuel_year_control.feature",
     "features/carrier.feature",
     "features/server_type.feature",
     "features/automobile_type_fuel_age.feature",
     "features/server_type_alias.feature",
     "features/automobile_make_fleet_year.feature",
     "features/fuel_year.feature",
     "spec/earth_spec.rb",
     "spec/earth/air/aircraft_spec.rb",
     "spec/earth/pet/species_spec.rb",
     "spec/spec_helper.rb",
     "Gemfile",
     "Gemfile.lock"
  ]
>>>>>>> Regenerated gemspec for version 0.3.13

  s.add_development_dependency 'sniff'
  if RUBY_VERSION >= '1.9'
    s.add_development_dependency 'ruby-debug19'
  else
    s.add_development_dependency 'ruby-debug'
  end
end
