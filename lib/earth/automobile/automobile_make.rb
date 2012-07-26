class AutomobileMake < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "automobile_makes"
  (
     "name"                  CHARACTER VARYING(255) NOT NULL,
     "fuel_efficiency"       FLOAT,
     "fuel_efficiency_units" CHARACTER VARYING(255)
  );
ALTER TABLE "automobile_makes" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  
  # for calculating fuel efficiency
  has_many :make_years, :foreign_key => :make_name, :primary_key => :name, :class_name => 'AutomobileMakeYear'
  
  
  warn_unless_size 81
end
