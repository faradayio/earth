Carrier.class_eval do
  data_miner do
    import "a list of shipping companies and their characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdG1ONU1HZDdZTFJNclFYVkRzR0k5Z2c&hl=en&gid=0&output=csv' do
      key   'name'
      store 'package_volume'
      store 'route_inefficiency_factor'
      store 'transport_emission_factor', :units_field_name => 'transport_emission_factor_units'
      store 'corporate_emission_factor', :units_field_name => 'corporate_emission_factor_units'
    end
    
    # TODO: derive package volume, route inefficiency factor, and transport emission factor
    # process "derive package volume, route inefficiency factor, and transport emission factor from CarrierModes" do
    #   CarrierMode.run_data_miner!
    #   
    #   carrier_modes = CarrierMode.arel_table
    #   carriers = Carrier.arel_table
    #   conditional_relation = carrier_modes[:include_in_fallbacks].and(carriers[:name].eq(carrier_modes[:carrier_name]))
    #   
    #   update_all "package_volume            = (#{carriers.project(sum(carriers[:package_volume]).where(conditional_relation)).to_sql})"
    #   update_all "route_inefficiency_factor = (#{CarrierMode.weighted_average_relation(:route_inefficiency_factor, :weighted_by => :package_volume).where(conditional_relation).to_sql})"
    #   update_all "transport_emission_factor = (#{CarrierMode.weighted_average_relation(:transport_emission_factor, :weighted_by => :package_volume).where(conditional_relation).to_sql})"
    #   what about transport_emission_factor_units?
    # end
    
    verify "Package volume should be greater than zero" do
      Carrier.all.each do |carrier|
        unless carrier.package_volume > 0
          raise "Invalid package volume for Carrier #{carrier.name}: #{carrier.package_volume} (should be > 0)"
        end
      end
    end
    
    verify "Route inefficiency factor should be one or more" do
      Carrier.all.each do |carrier|
        unless carrier.route_inefficiency_factor >= 1.0
          raise "Invalid route inefficiency factor for Carrier #{carrier.name}: #{carrier.route_inefficiency_factor} (should be >= 1.0)"
        end
      end
    end
    
    verify "Transport emission factor should be greater than zero" do
      Carrier.all.each do |carrier|
        unless carrier.transport_emission_factor > 0
          raise "Invalid transport emission factor for Carrier #{carrier.name}: #{carrier.transport_emission_factor} (should be > 0)"
        end
      end
    end
    
    verify "Transport emission factor units should never be missing" do
      Carrier.all.each do |carrier|
        unless carrier.transport_emission_factor_units.present?
          raise "Missing transport emission factor units for Carrier #{carrier.name}"
        end
      end
    end
    
    verify "Corporate emission factor should be greater than zero" do
      Carrier.all.each do |carrier|
        unless carrier.corporate_emission_factor > 0
          raise "Invalid corporate emission factor for Carrier #{carrier.name}: #{carrier.corporate_emission_factor} (should be > 0)"
        end
      end
    end
    
    verify "Corporate emission factor units should never be missing" do
      Carrier.all.each do |carrier|
        unless carrier.corporate_emission_factor_units.present?
          raise "Missing corporate emission factor units for Carrier #{carrier.name}"
        end
      end
    end
  end
end
