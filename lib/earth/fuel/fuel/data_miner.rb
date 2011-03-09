Fuel.class_eval do
  class IpccFuelParser
    def initialize(options = {})
      # nothing
    end
    
    def apply(row)
      # FIXME TODO
      # This should make the changes shown in https://spreadsheets.google.com/ccc?key=0AoQJbWqPrREqdDZ1dS1vYU5aQkJpQWt4UW0yby1XTFE&hl=en#gid=0
    end
  end
  
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'density'
      string 'density_units'
      string 'calorific_basis'
      float  'energy_content'
      string 'energy_content_units'
      float  'carbon_content'
      string 'carbon_content_units'
      float  'oxidation_factor'
      float  'biogenic_fraction'
      float  'co2_emission_factor'
      string 'co2_emission_factor_units'
      float  'co2_biogenic_emission_factor'
      string 'co2_biogenic_emission_factor_units'
    end
    
    import "global fuel data derived from the IPCC Guidelines for National Greenhouse Gas Inventories",
           :url => 'https://spreadsheets.google.com/pub?hl=en&hl=en&key=0AoQJbWqPrREqdFk5dzJvT2ozNjdEU05pWVJUTUpTOXc&gid=0&output=csv',
           :transform => { :class => IpccFuelParser } do
      key 'name'
      store 'calorific_basis'
      store 'energy_content', :units_field_name => 'energy_content_units'
      store 'carbon_content', :units_field_name => 'carbon_content_units'
      store 'oxidation_factor'
      store 'biogenic_fraction'
    end
    
    import "densities for aircraft fuels",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHBjTVE4NmRlc05iUHVZR1E3eEJwOGc&hl=en&gid=0&output=csv' do
      key 'name'
      store 'density', :units_field_name => 'density_units'
    end
    
    process "Calculate CO2 and CO2 biogenic emission factors" do
      conversion_factor = (1_000.0 / 1.0) * (1.0 / 1_000_000.0) * (44.0 / 12.0) # Google: 1000 Gg / 1 Tg * 1 Gg / 1_000_000 kg * 44 CO2 / 12 C
      connection.execute %{
        UPDATE fuels
        SET co2_emission_factor = carbon_content * energy_content * oxidation_factor * (1 - biogenic_fraction) * #{conversion_factor},
            co2_biogenic_emission_factor = carbon_content * energy_content * oxidation_factor * biogenic_fraction * #{conversion_factor},
            co2_emission_factor_units = 'kilograms_per_kilogram',
            co2_biogenic_emission_factor_units = 'kilograms_per_kilogram'
      }
    end
    
    # FIXME TODO verify this stuff
  end
end
