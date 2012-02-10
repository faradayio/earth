class CarrierMode < ActiveRecord::Base
  self.primary_key = "name"
  
  belongs_to :carrier, :foreign_key => 'carrier_name', :primary_key => 'name'
  belongs_to :mode,    :foreign_key => 'mode_name',    :primary_key => 'name', :class_name => 'ShipmentMode'

  col :name
  col :carrier_name
  col :mode_name
  col :package_volume, :type => :float
  col :route_inefficiency_factor, :type => :float
  col :transport_emission_factor, :type => :float
  col :transport_emission_factor_units
  
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
end
