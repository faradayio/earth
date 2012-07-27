require 'earth/model'

require 'earth/automobile/automobile_make_year'

class AutomobileMake < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "automobile_makes"
  (
     "name"                  CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "fuel_efficiency"       FLOAT,
     "fuel_efficiency_units" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"
  
  # for calculating fuel efficiency
  has_many :make_years, :foreign_key => :make_name, :primary_key => :name, :class_name => 'AutomobileMakeYear'
  
  
  warn_unless_size 81
end
