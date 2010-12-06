class LodgingClass < ActiveRecord::Base
  extend Earth::Base

  set_primary_key :name
  
  def self.schema_definition
    lambda do
      string 'name'
      float  'natural_gas_intensity'
      string 'natural_gas_intensity_units'
      float  'fuel_oil_intensity'
      string 'fuel_oil_intensity_units'
      float  'electricity_intensity'
      string 'electricity_intensity_units'
      float  'district_heat_intensity'
      string 'district_heat_intensity_units'
    end
  end
  
  data_miner do
    tap "Brighter Planet's lodging class data", Earth.taps_server
  end
end
