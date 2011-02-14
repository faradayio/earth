CarrierMode.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      string 'carrier_name'
      string 'mode_name'
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
      store 'package_volume'
      store 'route_inefficiency_factor'
      store 'transport_emission_factor', :units_field_name => 'transport_emission_factor_units'
    end
    
    # Don't need to check that carrier_name appears in carriers b/c carriers is derived from carrier_modes.carrier_name
    # Don't need to check that mode_name appears in shipment_modes b/c shipment_modes is derived from carrier_modes.mode_name
    # FIXME TODO test for valid transport_emission_factor_units
    %w{carrier_name mode_name transport_emission_factor_units}.each do |attribute|
      verify "#{attribute.humanize} should never be missing" do
        CarrierMode.all.each do |carrier_mode|
          value = carrier_mode.send(:"#{attribute}")
          unless value.present?
            raise "Missing #{attribute.humanize.downcase} for CarrierMode #{carrier_mode.name}"
          end
        end
      end
    end
    
    %w{package_volume transport_emission_factor}.each do |attribute|
      verify "#{attribute.humanize} should be greater than zero" do
        CarrierMode.all.each do |carrier_mode|
          value = carrier_mode.send(:"#{attribute}")
          unless value > 0
            raise "Invalid #{attribute.humanize.downcase} for CarrierMode #{carrier_mode.name}: #{value} (should be > 0)"
          end
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
  end
end
