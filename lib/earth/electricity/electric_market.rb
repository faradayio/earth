require 'earth/model'

require 'earth/electricity/electric_utility'
require 'earth/locality/zip_code'

class ElectricMarket < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE electric_markets
  (
     id                      CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     electric_utility_eia_id INTEGER,
     zip_code_name           CHARACTER VARYING(255)
  );

EOS

  self.primary_key = "id" # string
  
  belongs_to :electric_utility, :foreign_key => 'electric_utility_eia_id'
  belongs_to :zip_code, :foreign_key => 'zip_code_name'

  warn_unless_size 64864
end
