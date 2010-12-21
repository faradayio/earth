CarrierMode.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      string 'carrier_name'
      string 'mode_name'
      boolean 'include_in_fallbacks'
      float  'package_volume'
      float  'route_inefficiency_factor'
      float  'transport_emission_factor'
      string 'transport_emission_factor_units'
    end
    
    import "a list of carrier modes and their characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGRsRkJOd0NPd0FETTI0NmpYUlBsN2c&hl=en&single=true&gid=0&output=csv' do
      key   'name'
      store 'carrier_name'
      store 'mode_name'
      store 'include_in_fallbacks'
      store 'package_volume'
      store 'route_inefficiency_factor'
      store 'transport_emission_factor', :units_field_name => 'transport_emission_factor_units'
    end
    
    # Don't need to check that carrier_name appears in carriers b/c carriers is derived from carrier_modes.carrier_name
    verify "Carrier name should never be missing" do
      CarrierMode.all.each do |carrier_mode|
        if carrier_mode.carrier_name.nil?
          raise "Missing carrier name for CarrierMode #{carrier_mode.name}"
        end
      end
    end
    
    # Don't need to check that mode_name appears in shipment_modes b/c shipment_modes is derived from carrier_modes.mode_name
    verify "Mode name should never be missing" do
      CarrierMode.all.each do |carrier_mode|
        if carrier_mode.mode_name.nil?
          raise "Missing mode name for CarrierMode #{carrier_mode.name}"
        end
      end
    end
    
    verify "Include in fallbacks should never be missing" do
      CarrierMode.all.each do |carrier_mode|
        if carrier_mode.include_in_fallbacks.nil?
          raise "Missing include in fallbacks for CarrierMode #{carrier_mode.name}"
        end
      end
    end
    
    verify "Package volume should be greater than zero" do
      CarrierMode.all.each do |carrier_mode|
        unless carrier_mode.package_volume > 0
          raise "Invalid package volume for CarrierMode #{carrier_mode.name}: #{carrier_mode.package_volume} (should be > 0)"
        end
      end
    end
    
    verify "Route inefficiency factor should be one or more" do
      CarrierMode.all.each do |carrier_mode|
        unless carrier_mode.route_inefficiency_factor >= 1.0
          raise "Invalid route inefficiency factor for CarrierMode #{carrier_mode.name}: #{carrier_mode.route_inefficiency_factor} (should be >= 1.0)"
        end
      end
    end
    
    verify "Transport emission factor should be greater than zero" do
      CarrierMode.all.each do |carrier_mode|
        unless carrier_mode.transport_emission_factor > 0
          raise "Invalid transport emission factor for CarrierMode #{carrier_mode.name}: #{carrier_mode.transport_emission_factor} (should be > 0)"
        end
      end
    end
    
    verify "Transport emission factor units should never be missing" do
      CarrierMode.all.each do |carrier_mode|
        if carrier_mode.transport_emission_factor_units.nil?
          raise "Missing transport emission factor units for CarrierMode #{carrier_mode.name}"
        end
      end
    end
  end
end
