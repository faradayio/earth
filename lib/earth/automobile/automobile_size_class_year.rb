class AutomobileSizeClassYear < ActiveRecord::Base
  set_primary_key :name

  force_schema do
    string  'name'
    string  'size_class_name'
    integer 'year'
    string  'type_name'
    float   'fuel_efficiency_city'
    string  'fuel_efficiency_city_units'
    float   'fuel_efficiency_highway'
    string  'fuel_efficiency_highway_units'
  end
end
