# DEPRECATED but FuelPurchase still uses this
class FuelType < ActiveRecord::Base
  self.primary_key = :name
  
  has_many :prices, :class_name => 'FuelPrice', :foreign_key => 'name' # weird
  
  falls_back_on :emission_factor               => 1.0, #FIXME TODO put a real value here - also do we want to do emission factors in kg / kj?
                :emission_factor_units         => 'FIXME',
                :average_purchase_volume       => 100, #FIXME TODO put a real value here - also do we want to do volumes in kJ?
                :average_purchase_volume_units => 'FIXME'
  
  def price
    prices.average :price
  end
  
  col :name
  col :emission_factor, :type => :float
  col :emission_factor_units
  col :density, :type => :float
  col :density_units
  col :average_purchase_volume, :type => :float
  col :average_purchase_volume_units
  # col :energy_content, :type => :float
  # col :energy_content_units
  # col :carbon_content, :type => :float
  # col :carbon_content_units
end
