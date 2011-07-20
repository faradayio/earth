class FuelYear < ActiveRecord::Base
  set_primary_key :name
  
  force_schema do
    string  'name'
    string  'fuel_name'
    integer 'year'
    float   'energy_content'
    string  'energy_content_units'
    float   'carbon_content'
    string  'carbon_content_units'
    float   'oxidation_factor'
    float   'biogenic_fraction'
    float   'co2_emission_factor'
    string  'co2_emission_factor_units'
    float   'co2_biogenic_emission_factor'
    string  'co2_biogenic_emission_factor_units'
  end
end
