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
  end
end
