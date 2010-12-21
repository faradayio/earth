AutomobileSizeClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string   'name'
      string   'emblem'
      float    'annual_distance'
      string   'annual_distance_units'
      float    'fuel_efficiency_city'
      string   'fuel_efficiency_city_units'
      float    'fuel_efficiency_highway'
      string   'fuel_efficiency_highway_units'
      float    'hybrid_fuel_efficiency_city_multiplier'
      float    'hybrid_fuel_efficiency_highway_multiplier'
      float    'conventional_fuel_efficiency_city_multiplier'
      float    'conventional_fuel_efficiency_highway_multiplier'
    end

    import "a list of size classes and pre-calculated annual distances and fuel efficiencies",
           :url => 'http://static.brighterplanet.com/science/data/transport/automobiles/models_export/automobile_size_class.csv' do
      key 'name'
      store 'annual_distance', :units => :kilometres
      store 'fuel_efficiency_city', :units => :kilometres_per_litre
      store 'fuel_efficiency_highway', :units => :kilometres_per_litre
    end

    # Ian 5/27/2010 I'm pretty sure we don't need emblems in middleware
    # import "",
    #        :url => 'http://static.brighterplanet.com/science/data/transport/automobiles/models_export/automobile_size_class_emblems.csv' do
    #   key 'name'
    #   store 'emblem'
    # end
    
    import "pre-calculated hybridity multipliers",
           :url => 'http://static.brighterplanet.com/science/data/transport/automobiles/vehicle_classes/fuel_efficiency_multipliers.csv' do
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
            if not multiplier.nil?
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
