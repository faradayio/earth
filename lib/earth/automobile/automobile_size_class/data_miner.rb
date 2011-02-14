AutomobileSizeClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      string 'type_name'
      float  'annual_distance'
      string 'annual_distance_units'
      float  'fuel_efficiency_city'
      string 'fuel_efficiency_city_units'
      float  'fuel_efficiency_highway'
      string 'fuel_efficiency_highway_units'
      float  'hybrid_fuel_efficiency_city_multiplier'
      float  'hybrid_fuel_efficiency_highway_multiplier'
      float  'conventional_fuel_efficiency_city_multiplier'
      float  'conventional_fuel_efficiency_highway_multiplier'
    end
    
    import "a list of size classes and pre-calculated fuel efficiencies",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHlRUE5IcWlrRENhN0EtUldPTy1rX1E&single=true&gid=0&output=csv' do
      key 'name'
      store 'type_name'
      store 'fuel_efficiency_city', :units_field_name => 'fuel_efficiency_city_units'
      store 'fuel_efficiency_highway', :units_field_name => 'fuel_efficiency_highway_units'
    end
    
    # FIXME TODO make this a method on AutomobileSizeClass?
    process "Calculate annual distance from AutomobileTypeFuelAge" do
      AutomobileTypeFuelAge.run_data_miner!
      ages = AutomobileTypeFuelAge.arel_table
      classes = AutomobileSizeClass.arel_table
      conditional_relation = ages[:type_name].eq(classes[:type_name])
      update_all "annual_distance = (#{AutomobileTypeFuelAge.weighted_average_relation(:annual_distance, :weighted_by => :vehicles).where(conditional_relation).to_sql})"
      update_all "annual_distance_units = 'kilometres'"
    end
    
    import "pre-calculated fuel efficiency multipliers",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGt2NnhXLXUxNFRJSzczU3BkSHB3enc&hl=en&single=true&gid=0&output=csv' do
      key 'name'
      store 'hybrid_fuel_efficiency_city_multiplier'
      store 'hybrid_fuel_efficiency_highway_multiplier'
      store 'conventional_fuel_efficiency_city_multiplier'
      store 'conventional_fuel_efficiency_highway_multiplier'
    end
    
    verify "Annual distance should be greater than zero" do
      AutomobileSizeClass.all.each do |size_class|
        unless size_class.annual_distance > 0
          raise "Invalid annual distance for AutomobileSizeClass #{size_class.name}: #{size_class.annual_distance} (should be > 0)"
        end
      end
    end
    
    verify "Annual distance units should be kilometres" do
      AutomobileSizeClass.all.each do |size_class|
        unless size_class.annual_distance_units == "kilometres"
          raise "Invalid annual distance units for AutomobileSizeClass #{size_class.name}: #{size_class.annual_distance_units} (should be kilometres)"
        end
      end
    end
    
     verify "Fuel efficiencies should be greater than zero" do
      AutomobileSizeClass.all.each do |size_class|
        %w{ city highway }.each do |type|
          fuel_efficiency = size_class.send(:"fuel_efficiency_#{type}")
          unless fuel_efficiency > 0
            raise "Invalid fuel efficiency #{type} for AutomobileSizeClass #{size_class.name}: #{fuel_efficiency} (should be > 0)"
          end
        end
      end
    end
    
    verify "Fuel efficiency units should be kilometres per litre" do
      AutomobileSizeClass.all.each do |size_class|
        %w{ city highway }.each do |type|
          units = size_class.send(:"fuel_efficiency_#{type}_units")
          unless units == "kilometres_per_litre"
            raise "Invalid fuel efficiency #{type} units for AutomobileSizeClass #{size_class.name}: #{units} (should be kilometres_per_litre)"
          end
        end
      end
    end
    
    verify "Any fuel efficiency multipliers should be greater than zero" do
      AutomobileSizeClass.all.each do |size_class|
        %w{ hybrid conventional }.each do |hybridity|
          %w{ city highway }.each do |type|
            multiplier = size_class.send(:"#{hybridity}_fuel_efficiency_#{type}_multiplier")
            if multiplier.present?
              unless multiplier > 0
                raise "Invalid #{hybridity} fuel efficiency #{type} multiplier for AutomobileSizeClass #{size_class.name}: #{multiplier} (should be > 0)"
              end
            end
          end
        end
      end
    end
    
    verify "Fallback fuel efficiency multipliers should be greater than zero" do
      %w{ hybrid conventional }.each do |hybridity|
        %w{ city highway }.each do |type|
          multiplier = AutomobileSizeClass.fallback.send(:"#{hybridity}_fuel_efficiency_#{type}_multiplier")
          unless multiplier > 0
            raise "Invalid AutomobileSizeClass fallback #{hybridity} fuel efficiency #{type} multiplier: #{multiplier} (should be > 0)"
          end
        end
      end
    end
  end
end
