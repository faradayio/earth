AutomobileTypeFuelYear.class_eval do
  data_miner do
    schema Earth.database_options do
      string  'name'
      string  'type_name'
      string  'fuel_common_name'
      integer 'year'
      float   'total_travel'
      string  'total_travel_units'
    end
    
    import "total vehicle miles travelled by gasoline passenger cars from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-87.csv',
           :skip => 1 do
      key   'name', :synthesize => lambda { |row| "Passenger cars gasoline #{row['Year']}" if row['Year'].length < 5 }
      store 'type_name', :static => 'Passenger cars'
      store 'fuel_common_name', :static => 'gasoline'
      store 'year', :field_name => 'Year'
      store 'total_travel', :field_name => 'Passenger Cars', :units => :billion_miles
    end
    
    import "total vehicle miles travelled by gasoline light-duty trucks from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-87.csv',
           :skip => 1 do
      key   'name', :synthesize => lambda { |row| "Light-duty trucks gasoline #{row['Year']}" if row['Year'].length < 5 }
      store 'type_name', :static => 'Light-duty trucks'
      store 'fuel_common_name', :static => 'gasoline'
      store 'year', :field_name => 'Year'
      store 'total_travel', :field_name => 'Light-Duty Trucks', :units => :billion_miles
    end
    
    import "total vehicle miles travelled by diesel passenger cars from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-88.csv',
           :skip => 1 do
      key   'name', :synthesize => lambda { |row| "Passenger cars diesel #{row['Year']}" if row['Year'].length < 5 }
      store 'type_name', :static => 'Passenger cars'
      store 'fuel_common_name', :static => 'diesel'
      store 'year', :field_name => 'Year'
      store 'total_travel', :field_name => 'Passenger Cars', :units => :billion_miles
    end
    
    import "total vehicle miles travelled by diesel light-duty trucks from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-88.csv',
           :skip => 1 do
      key   'name', :synthesize => lambda { |row| "Light-duty trucks diesel #{row['Year']}" if row['Year'].length < 5 }
      store 'type_name', :static => 'Light-duty trucks'
      store 'fuel_common_name', :static => 'diesel'
      store 'year', :field_name => 'Year'
      store 'total_travel', :field_name => 'Light-Duty Trucks', :units => :billion_miles
    end
    
    process "Convert total travel from billion miles to kilometres" do
      conversion_factor = 1_000_000_000.miles.to(:kilometres)
      update_all "total_travel = total_travel * #{conversion_factor}"
      update_all "total_travel_units = 'kilometres'"
    end
    
    verify "Type name and fuel common name should never be missing" do
      AutomobileTypeFuelYear.all.each do |record|
        %w{ type_name fuel_common_name }.each do |attribute|
          value = record.send(:"#{attribute}")
          if value.nil?
            raise "Missing #{attribute} for AutomobileTypeFuelYear '#{record.name}'"
          end
        end
      end
    end
    
    verify "Year should be between 1990 and 2008" do
      AutomobileTypeFuelYear.all.each do |record|
        year = record.send(:year)
        unless year > 1989 and year < 2009
          raise "Invalid year for AutomobileTypeFuelYear '#{record.name}': #{year} (should be between 1990 and 2008)"
        end
      end
    end
    
    verify "Total travel should be greater than zero" do
      AutomobileTypeFuelYear.all.each do |record|
        travel = record.send(:total_travel)
        unless travel > 0
          raise "Invalid total travel for AutomobileTypeFuelYear '#{record.name}': #{travel} (should be > 0)"
        end
      end
    end
    
    verify "Total travel units should be kilometres" do
      AutomobileTypeFuelYear.all.each do |record|
        units = record.send(:total_travel_units)
        unless units == "kilometres"
          raise "Invalid total travel units for AutomobileTypeFuelYear '#{record.name}': #{units} (should be kilometres)"
        end
      end
    end
  end
end
