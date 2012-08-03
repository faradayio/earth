require 'falls_back_on'

require 'earth/model'

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
  
  falls_back_on :name => 'fallback',
                :electricity_intensity => lambda { ComputationCarrierInstanceClass.find_by_name('Amazon m1.small').electricity_intensity },
                :electricity_intensity_units => lambda { ComputationCarrierInstanceClass.find_by_name('Amazon m1.small').electricity_intensity_units }
  
  
  # FIXME TODO verify that computation carrier name appears in computation_carriers
  
  # verify "Electricity intensity should be more than zero" do
  #   ComputationCarrierInstanceClass.all.each do |instance_class|
  #     unless instance_class.electricity_intensity > 0
  #       raise "Invalid electricity intensity for ComputationCarrierInstanceClass #{instance_class.name}: #{instance_class.electricity_intensity} (should be > 0)"
  #     end
  #   end
  # end
  # 
  # verify "Electricity intensity units should be kilowatts" do
  #   ComputationCarrierInstanceClass.all.each do |instance_class|
  #     unless instance_class.electricity_intensity_units == 'kilowatts'
  #       raise "Invalid electricity intensity units for ComputationCarrierInstanceClass #{instance_class.name}: #{instance_class.electricity_intensity_units} (should be kilowatts)"
  #     end
  #   end
  # end
  

  warn_unless_size 8
end
