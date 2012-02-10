class Carrier < ActiveRecord::Base
  self.primary_key = "name"
  
  has_many :carrier_modes, :foreign_key => 'carrier_name', :primary_key => 'name'
  
  # TODO calculate these
  falls_back_on :route_inefficiency_factor => 1.03,
                :transport_emission_factor => 0.0005266,
                :corporate_emission_factor => 0.221
  
  col :name
  col :full_name
  col :package_volume, :type => :float
  col :route_inefficiency_factor, :type => :float
  col :transport_emission_factor, :type => :float
  col :transport_emission_factor_units
  col :corporate_emission_factor, :type => :float
  col :corporate_emission_factor_units
  
  # verify "Package volume should be greater than zero" do
  #   Carrier.all.each do |carrier|
  #     unless carrier.package_volume > 0
  #       raise "Invalid package volume for Carrier #{carrier.name}: #{carrier.package_volume} (should be > 0)"
  #     end
  #   end
  # end
  # 
  # verify "Route inefficiency factor should be one or more" do
  #   Carrier.all.each do |carrier|
  #     unless carrier.route_inefficiency_factor >= 1.0
  #       raise "Invalid route inefficiency factor for Carrier #{carrier.name}: #{carrier.route_inefficiency_factor} (should be >= 1.0)"
  #     end
  #   end
  # end
  # 
  # verify "Transport emission factor should be greater than zero" do
  #   Carrier.all.each do |carrier|
  #     unless carrier.transport_emission_factor > 0
  #       raise "Invalid transport emission factor for Carrier #{carrier.name}: #{carrier.transport_emission_factor} (should be > 0)"
  #     end
  #   end
  # end
  # 
  # verify "Transport emission factor units should never be missing" do
  #   Carrier.all.each do |carrier|
  #     unless carrier.transport_emission_factor_units.present?
  #       raise "Missing transport emission factor units for Carrier #{carrier.name}"
  #     end
  #   end
  # end
  # 
  # verify "Corporate emission factor should be greater than zero" do
  #   Carrier.all.each do |carrier|
  #     unless carrier.corporate_emission_factor > 0
  #       raise "Invalid corporate emission factor for Carrier #{carrier.name}: #{carrier.corporate_emission_factor} (should be > 0)"
  #     end
  #   end
  # end
  # 
  # verify "Corporate emission factor units should never be missing" do
  #   Carrier.all.each do |carrier|
  #     unless carrier.corporate_emission_factor_units.present?
  #       raise "Missing corporate emission factor units for Carrier #{carrier.name}"
  #     end
  #   end
  # end
  
end
