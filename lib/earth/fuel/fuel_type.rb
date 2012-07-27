require 'falls_back_on'

require 'earth/model'

# DEPRECATED but FuelPurchase still uses this
class FuelType < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "fuel_types"
  (
     "name"                          CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "emission_factor"               FLOAT,
     "emission_factor_units"         CHARACTER VARYING(255),
     "density"                       FLOAT,
     "density_units"                 CHARACTER VARYING(255),
     "average_purchase_volume"       FLOAT,
     "average_purchase_volume_units" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"
  
  has_many :prices, :class_name => 'FuelPrice', :foreign_key => 'name' # weird
  
  falls_back_on :emission_factor               => 1.0, #FIXME TODO put a real value here - also do we want to do emission factors in kg / kj?
                :emission_factor_units         => 'FIXME',
                :average_purchase_volume       => 100, #FIXME TODO put a real value here - also do we want to do volumes in kJ?
                :average_purchase_volume_units => 'FIXME'
  
  def price
    prices.average :price
  end
  
  warn_unless_size 36
end
