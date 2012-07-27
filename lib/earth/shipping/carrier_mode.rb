require 'earth/model'

class CarrierMode < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "carrier_modes"
  (
     "name"                            CHARACTER VARYING(255) NOT NULL,
     "carrier_name"                    CHARACTER VARYING(255),
     "mode_name"                       CHARACTER VARYING(255),
     "package_volume"                  FLOAT,
     "route_inefficiency_factor"       FLOAT,
     "transport_emission_factor"       FLOAT,
     "transport_emission_factor_units" CHARACTER VARYING(255)
  );
ALTER TABLE "carrier_modes" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  
  belongs_to :carrier, :foreign_key => 'carrier_name', :primary_key => 'name'
  belongs_to :mode,    :foreign_key => 'mode_name',    :primary_key => 'name', :class_name => 'ShipmentMode'

  
  # Don't need to check that carrier_name appears in carriers b/c carriers is derived from carrier_modes.carrier_name
  # Don't need to check that mode_name appears in shipment_modes b/c shipment_modes is derived from carrier_modes.mode_name
  # FIXME TODO test for valid transport_emission_factor_units
  # %w{carrier_name mode_name transport_emission_factor_units}.each do |attribute|
  #   verify "#{attribute.humanize} should never be missing" do
  #     CarrierMode.all.each do |carrier_mode|
  #       value = carrier_mode.send(:"#{attribute}")
  #       unless value.present?
  #         raise "Missing #{attribute.humanize.downcase} for CarrierMode #{carrier_mode.name}"
  #       end
  #     end
  #   end
  # end
  # 
  # %w{package_volume transport_emission_factor}.each do |attribute|
  #   verify "#{attribute.humanize} should be greater than zero" do
  #     CarrierMode.all.each do |carrier_mode|
  #       value = carrier_mode.send(:"#{attribute}")
  #       unless value > 0
  #         raise "Invalid #{attribute.humanize.downcase} for CarrierMode #{carrier_mode.name}: #{value} (should be > 0)"
  #       end
  #     end
  #   end
  # end
  # 
  # verify "Route inefficiency factor should be one or more" do
  #   CarrierMode.all.each do |carrier_mode|
  #     unless carrier_mode.route_inefficiency_factor >= 1.0
  #       raise "Invalid route inefficiency factor for CarrierMode #{carrier_mode.name}: #{carrier_mode.route_inefficiency_factor} (should be >= 1.0)"
  #     end
  #   end
  # end

  warn_unless_size 9
end
