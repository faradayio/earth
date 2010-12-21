ShipmentMode.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'route_inefficiency_factor'
      float  'transport_emission_factor'
      string 'transport_emission_factor_units'
    end
    
    import "a list of shipment modes and their characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGR2a2RYcEg2RnRKbkRQcXc0ZkQ5U0E&hl=en&single=true&gid=0&output=csv' do
      key   'name'
      store 'route_inefficiency_factor'
      store 'transport_emission_factor', :units_field_name => 'transport_emission_factor_units'
    end
    
    # TODO: derive route inefficiency factor and transport emission factor
    # process "derive route inefficiency factor and transport emission factor from CarrierModes" do
    #   CarrierMode.run_data_miner!
    #   
    #   carrier_modes = CarrierMode.arel_table
    #   modes = ShipmentMode.arel_table
    #   
    #   update_all "route_inefficiency_factor = (#{CarrierMode.weighted_average_relation(:route_inefficiency_factor, :weighted_by => :package_volume).where(modes[:name].eq(carrier_modes[:mode_name])).to_sql})"
    #   update_all "transport_emission_factor = (#{CarrierMode.weighted_average_relation(:transport_emission_factor, :weighted_by => :package_volume).where(modes[:name].eq(carrier_modes[:mode_name])).to_sql})"
    #   what about transport_emission_factor_units?
    # end
    
    verify "Route inefficiency factor should be one or more" do
      ShipmentMode.all.each do |mode|
        unless mode.route_inefficiency_factor >= 1.0
          raise "Invalid route inefficiency factor for ShipmentMode #{mode.name}: #{mode.route_inefficiency_factor} (should be >= 1.0)"
        end
      end
    end
    
    verify "Transport emission factor should be greater than zero" do
      ShipmentMode.all.each do |mode|
        unless mode.transport_emission_factor > 0
          raise "Invalid transport emission factor for ShipmentMode #{mode.name}: #{mode.transport_emission_factor} (should be > 0)"
        end
      end
    end
    
    verify "Transport emission factor units should never be missing" do
      ShipmentMode.all.each do |mode|
        if mode.transport_emission_factor_units.nil?
          raise "Missing transport emission factor units for ShipmentMode #{mode.name}"
        end
      end
    end
  end
end
