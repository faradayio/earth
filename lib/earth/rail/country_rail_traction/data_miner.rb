require 'earth/fuel/data_miner'
require 'earth/locality/data_miner'
CountryRailTraction.class_eval do
  data_miner do
    import "european rail traction data from the UIC",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdHA1RmZ0SlN6ZkVOenRodGFBQ1N0Q2c&output=csv' do
      key 'name', :synthesize => lambda { |record| [record['country_iso_3166_code'], record['rail_traction_name']].join(' ') }
      store 'country_iso_3166_code'
      store 'rail_traction_name'
      store 'electricity_intensity', :nullify => :true, :units_field_name => 'electricity_intensity_units'
      store 'diesel_intensity',      :nullify => :true, :units_field_name => 'diesel_intensity_units'
      store 'co2_emission_factor',   :nullify => :true, :units_field_name => 'co2_emission_factor_units'
    end
    
    process "Ensure RailFuel is populated" do
      RailFuel.run_data_miner!
    end
    
    process "Standardize diesel intensity units" do
      CountryRailTraction.where(:diesel_intensity_units => 'grams_per_passenger_kilometre').find_each do |record|
        diesel = RailFuel.find_by_name("diesel")
        record.diesel_intensity = record.diesel_intensity.grams.to(:kilograms) / diesel.density
        record.diesel_intensity_units = [diesel.density_units.split("_per_")[1].pluralize, record.diesel_intensity_units.split("_per_")[1]].join('_per_')
        record.save!
      end
    end
    
    process "Standardize co2 emission factor units" do
      CountryRailTraction.where(:co2_emission_factor_units => 'grams_per_passenger_kilometre').find_each do |record|
        record.co2_emission_factor = record.co2_emission_factor.grams.to(:kilograms)
        record.co2_emission_factor_units = ['kilograms', record.co2_emission_factor_units.split("_per_")[1]].join('_per_')
        record.save!
      end
    end
  end
end
