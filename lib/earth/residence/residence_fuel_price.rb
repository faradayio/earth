require 'earth/model'
require 'earth/locality'
class ResidenceFuelPrice < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "residence_fuel_prices"
  (
     "row_hash"                 CHARACTER VARYING(255) NOT NULL,
     "residence_fuel_type_name" CHARACTER VARYING(255),
     "year"                     INTEGER,
     "month"                    INTEGER,
     "price"                    FLOAT,
     "price_units"              CHARACTER VARYING(255),
     "price_description"        CHARACTER VARYING(255),
     "locatable_id"             CHARACTER VARYING(255),
     "locatable_type"           CHARACTER VARYING(255)
  );
ALTER TABLE "residence_fuel_prices" ADD PRIMARY KEY ("row_hash");
CREATE INDEX "index_residence_fuel_prices_on_price_and_residence_fu239358947" ON "residence_fuel_prices" ("price", "residence_fuel_type_name", "month", "year", "locatable_type", "locatable_id");
CREATE INDEX "index_residence_fuel_prices_on_price_and_residence_fu1975072203" ON "residence_fuel_prices" ("price", "residence_fuel_type_name")
EOS

  self.primary_key = "row_hash"
  
  belongs_to :fuel, :class_name => 'ResidenceFuelType', :foreign_key => 'residence_fuel_type_name'
  belongs_to :locatable, :polymorphic => true
  

  warn_unless_size 13639
end
