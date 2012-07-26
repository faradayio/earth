class ShipmentMode < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "shipment_modes"
  (
     "name"                            CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "route_inefficiency_factor"       FLOAT,
     "transport_emission_factor"       FLOAT,
     "transport_emission_factor_units" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"
  
  has_many :carrier_modes, :foreign_key => 'mode_name', :primary_key => 'name'
  
  
  # verify "Route inefficiency factor should be one or more" do
  #   ShipmentMode.all.each do |mode|
  #     unless mode.route_inefficiency_factor >= 1.0
  #       raise "Invalid route inefficiency factor for ShipmentMode #{mode.name}: #{mode.route_inefficiency_factor} (should be >= 1.0)"
  #     end
  #   end
  # end
  # 
  # verify "Transport emission factor should be greater than zero" do
  #   ShipmentMode.all.each do |mode|
  #     unless mode.transport_emission_factor > 0
  #       raise "Invalid transport emission factor for ShipmentMode #{mode.name}: #{mode.transport_emission_factor} (should be > 0)"
  #     end
  #   end
  # end
  # 
  # verify "Transport emission factor units should never be missing" do
  #   ShipmentMode.all.each do |mode|
  #     unless mode.transport_emission_factor_units.present?
  #       raise "Missing transport emission factor units for ShipmentMode #{mode.name}"
  #     end
  #   end
  # end
  

  warn_unless_size 3
end
