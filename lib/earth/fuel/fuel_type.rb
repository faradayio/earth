class FuelType < ActiveRecord::Base
  set_primary_key :name
  
  has_many :prices, :class_name => 'FuelPrice', :foreign_key => 'name' # weird
  
  falls_back_on :emission_factor               => 1.0, #FIXME TODO put a real value here - also do we want to do emission factors in kg / kj?
                :emission_factor_units         => 'FIXME',
                :average_purchase_volume       => 100, #FIXME TODO put a real value here - also do we want to do volumes in kJ?
                :average_purchase_volume_units => 'FIXME'
  
  def price
    prices.average :price
  end
  
  force_schema do
    string 'name'
    float  'emission_factor'
    string 'emission_factor_units'
    float  'density'
    string 'density_units'
    float  'average_purchase_volume'
    string 'average_purchase_volume_units'
    # float    'energy_content'
    # string   'energy_content_units'
    # float    'carbon_content'
    # string   'carbon_content_units'
  end
end
