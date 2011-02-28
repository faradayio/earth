AutomobileSizeClassYear.class_eval do
  data_miner do
    schema Earth.database_options do
      string  'name'
      string  'size_class_name'
      integer 'year'
      string  'type_name'
      float   'fuel_efficiency_city'
      string  'fuel_efficiency_city_units'
      float   'fuel_efficiency_highway'
      string  'fuel_efficiency_highway_units'
    end
    
    import "automobile size class year fuel efficiencies from the 2010 EPA Fuel Economy Trends report",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdDZOLWdDdlZja04xZkJYc3NjeGxQamc&hl=en&gid=0&output=csv' do
      key 'name'
      store 'size_class_name'
      store 'year'
      store 'type_name'
      store 'fuel_efficiency_city', :units_field_name => 'fuel_efficiency_city_units'
      store 'fuel_efficiency_highway', :units_field_name => 'fuel_efficiency_highway_units'
    end
    
    # FIXME TODO verify that size_class_name is never missing?
    # FIXME TODO verify that type_name appears in AutomobileTypeFuelYearAges
    
    verify "Year should be from 1975 to 2010" do
      AutomobileSizeClassYear.all.each do |record|
        unless record.year > 1974 and record.year < 2011
          raise "Invalid year for AutomobileSizeClassYear #{record.name}: #{record.year} (should be from 1975 to 2010)"
        end
      end
    end
    
    verify "Fuel efficiencies should be greater than zero" do
      AutomobileSizeClassYear.all.each do |year|
        %w{ fuel_efficiency_city fuel_efficiency_highway }.each do |attribute|
          value = year.send(:"#{attribute}")
          unless value > 0
            raise "Invalid #{attribute} for AutomobileSizeClassYear #{year.name}: #{value} (should be > 0)"
          end
        end
      end
    end
    
    verify "Fuel efficiency units should be kilometres per litre" do
      AutomobileSizeClassYear.all.each do |year|
        %w{ fuel_efficiency_city_units fuel_efficiency_highway_units }.each do |attribute|
          value = year.send(:"#{attribute}")
          unless value == "kilometres_per_litre"
            raise "Invalid #{attribute} for AutomobileSizeClassYear #{year.name}: #{value} (should be kilometres_per_litre)"
          end
        end
      end
    end
  end
end
