require 'earth/model'
require 'falls_back_on'

require 'earth/computation/computation_carrier'

class ComputationCarrierInstanceClass < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE computation_carrier_instance_classes
  (
     name                        CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     computation_carrier_name    CHARACTER VARYING(255),
     instance_class              CHARACTER VARYING(255),
     electricity_intensity       FLOAT,
     electricity_intensity_units CHARACTER VARYING(255)
  );

EOS

  self.primary_key = "name"
  
  belongs_to :carrier, :class_name => 'ComputationCarrier', :foreign_key => 'computation_carrier_name'
  
  def self.fallback
    find_by_name 'Amazon m1.small'
  end
  
  warn_unless_size 8
end
