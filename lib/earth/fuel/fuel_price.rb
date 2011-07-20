class FuelPrice < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :fuel_type, :foreign_key => 'name' # weird
  
  force_schema do
    string  'name'
    float   'price'
    string  'price_units'
  end
end
