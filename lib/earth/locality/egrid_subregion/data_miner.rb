EgridSubregion.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'abbreviation'
      string 'name'
      float  'electricity_emission_factor'
      string 'electricity_emission_factor_units'
      string 'nerc_abbreviation'
      string 'egrid_region_name'
    end
    
    process "Define some unit conversions" do
      Conversions.register :kilograms_per_kilowatt_hour, :kilograms_per_megawatt_hour, 1_000.0
    end
    
    import "a list of eGRID subregions and pre-calculated emissions factors",
           :url => 'http://static.brighterplanet.com/science/data/electricity/egrid/models_export/egrid_subregions.csv' do
      key   'abbreviation'
      store 'name'
      store 'electricity_emission_factor', :from_units => :kilograms_per_megawatt_hour, :to_units => :kilograms_per_kilowatt_hour
      store 'nerc_abbreviation'
      store 'egrid_region_name'
    end
  end
end

