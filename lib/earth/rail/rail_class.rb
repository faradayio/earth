class RailClass < ActiveRecord::Base
  set_primary_key :name
  force_schema do
    string 'name'
    string 'description'
    float  'passengers'
    float  'distance'
    string 'distance_units'
    float  'speed'
    string 'speed_units'
    float  'electricity_intensity'
    string 'electricity_intensity_units'
    float  'diesel_intensity'
    string 'diesel_intensity_units'
  end
end
