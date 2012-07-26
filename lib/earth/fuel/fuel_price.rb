class FuelPrice < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "fuel_prices"
  (
     "name"        CHARACTER VARYING(255) NOT NULL,
     "price"       FLOAT,
     "price_units" CHARACTER VARYING(255)
  );
ALTER TABLE "fuel_prices" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  
  belongs_to :fuel_type, :foreign_key => 'name' # weird
  

  warn_unless_size 34
end
