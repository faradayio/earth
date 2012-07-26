require 'earth/locality'

class ElectricMarket < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "electric_markets"
  (
     "id"                      CHARACTER VARYING(255) NOT NULL,
     "electric_utility_eia_id" INTEGER,
     "zip_code_name"           CHARACTER VARYING(255)
  );
ALTER TABLE "electric_markets" ADD PRIMARY KEY ("id")
EOS

  self.primary_key = "id" # string
  
  belongs_to :electric_utility, :foreign_key => 'electric_utility_eia_id'
  belongs_to :zip_code, :foreign_key => 'zip_code_name'
  
end
