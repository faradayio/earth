require 'earth/model'

require 'earth/fuel/fuel_type'

class FuelPrice < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE fuel_prices
  (
     name        CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     price       FLOAT,
     price_units CHARACTER VARYING(255)
  );

EOS

  self.primary_key = "name"
  
  belongs_to :fuel_type, :foreign_key => 'name' # weird
  

  warn_unless_size 34
end
