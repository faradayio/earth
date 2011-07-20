class BusFuel < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :fuel, :foreign_key => 'fuel_name'
  has_many :fuel_year_controls, :class_name => 'BusFuelYearControl', :foreign_key => 'bus_fuel_name'
    
  def latest_fuel_year_controls
    fuel_year_controls.where(:year => fuel_year_controls.maximum('year'))
  end
  
  force_schema do
    string 'name'
    string 'fuel_name'
    float  'energy_content'
    string 'energy_content_units'
    float  'co2_emission_factor'
    string 'co2_emission_factor_units'
    float  'co2_biogenic_emission_factor'
    string 'co2_biogenic_emission_factor_units'
    float  'ch4_emission_factor'
    string 'ch4_emission_factor_units'
    float  'n2o_emission_factor'
    string 'n2o_emission_factor_units'
  end
end
