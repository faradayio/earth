class FuelPrice < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :fuel_type, :foreign_key => 'name' # weird
  
  create_table do
    string  'name'
    float   'price'
    string  'price_units'
  end
end
