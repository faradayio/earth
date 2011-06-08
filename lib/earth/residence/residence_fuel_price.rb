class ResidenceFuelPrice < ActiveRecord::Base
  set_primary_key :row_hash
  
  extend CohortScope
  self.minimum_cohort_size = 5 # ? FIXME
  
  belongs_to :fuel, :class_name => 'ResidenceFuelType', :foreign_key => 'residence_fuel_type_name'
  belongs_to :locatable, :polymorphic => true
  
  create_table do
    string  'row_hash'
    string 'residence_fuel_type_name'
    integer 'year'
    integer 'month'
    float   'price'
    string  'price_units'
    string  'price_description'
    string  'locatable_id'
    string  'locatable_type'
    index   ['price', 'residence_fuel_type_name', 'month', 'year', 'locatable_type', 'locatable_id']
    index   ['price', 'residence_fuel_type_name']
  end
end
