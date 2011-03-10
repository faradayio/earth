AutomobileTypeFuelYearAge.class_eval do
  data_miner do
    schema Earth.database_options do
      string  'name'
      string  'type_name'
      string  'fuel_common_name'
      integer 'year'
      integer 'age'
      string  'type_fuel_year_name'
      float   'total_travel_percent'
      float   'annual_distance'
      string  'annual_distance_units'
      integer 'vehicles'
    end
    
    import "total travel distribution of gasoline passenger cars from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-93.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Passenger cars gasoline 2008 age #{row['Vehicle Age']}" }
      store 'type_name', :static => 'Passenger cars'
      store 'fuel_common_name', :static => 'gasoline'
      store 'year', :static => '2008'
      store 'age', :field_name => 'Vehicle Age'
      store 'total_travel_percent', :synthesize => lambda { |row| row['LDGV'].to_f / 100 }
    end
    
    import "total travel distribution of gasoline light-duty trucks from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-93.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Light-duty trucks gasoline 2008 age #{row['Vehicle Age']}" }
      store 'type_name', :static => 'Light-duty trucks'
      store 'fuel_common_name', :static => 'gasoline'
      store 'year', :static => '2008'
      store 'age', :field_name => 'Vehicle Age'
      store 'total_travel_percent', :synthesize => lambda { |row| row['LDGT'].to_f / 100 }
    end
    
    import "total travel distribution of diesel passenger cars from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-93.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Passenger cars diesel 2008 age #{row['Vehicle Age']}" }
      store 'type_name', :static => 'Passenger cars'
      store 'fuel_common_name', :static => 'diesel'
      store 'year', :static => '2008'
      store 'age', :field_name => 'Vehicle Age'
      store 'total_travel_percent', :synthesize => lambda { |row| row['LDDV'].to_f / 100 }
    end
    
    import "total travel distribution of diesel light-duty trucks from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-93.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Light-duty trucks diesel 2008 age #{row['Vehicle Age']}" }
      store 'type_name', :static => 'Light-duty trucks'
      store 'fuel_common_name', :static => 'diesel'
      store 'year', :static => '2008'
      store 'age', :field_name => 'Vehicle Age'
      store 'total_travel_percent', :synthesize => lambda { |row| row['LDDT'].to_f / 100 }
    end
    
    import "average annual distance for gasoline passenger cars from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-92.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Passenger cars gasoline 2008 age #{row['Vehicle Age']}" }
      store 'annual_distance', :synthesize => lambda { |row| row['LDGV'].to_s.sub(',', '') }, :units => :miles
    end
    
    import "average annual distance for gasoline light-duty trucks from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-92.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Light-duty trucks gasoline 2008 age #{row['Vehicle Age']}" }
      store 'annual_distance', :synthesize => lambda { |row| row['LDGT'].to_s.sub(',', '') }, :units => :miles
    end
    
    import "average annual distance for diesel passenger cars from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-92.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Passenger cars diesel 2008 age #{row['Vehicle Age']}" }
      store 'annual_distance', :synthesize => lambda { |row| row['LDDV'].to_s.sub(',', '') }, :units => :miles
    end
    
    import "average annual distance for diesel light-duty trucks from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-92.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Light-duty trucks diesel 2008 age #{row['Vehicle Age']}" }
      store 'annual_distance', :synthesize => lambda { |row| row['LDDT'].to_s.sub(',', '') }, :units => :miles
    end
    
    process "Convert annual distance from miles to kilometres" do
      conversion_factor = 1.miles.to(:kilometres)
      connection.execute %{
        UPDATE automobile_type_fuel_year_ages
        SET annual_distance = annual_distance * #{conversion_factor},
            annual_distance_units = 'kilometres'
        WHERE annual_distance_units = 'miles'
      }
    end
    
    process "Derive type fuel year name for association with AutomobileTypeFuelYear" do
      if ActiveRecord::Base.connection.adapter_name.downcase == 'sqlite'
        update_all "type_fuel_year_name = type_name || ' ' || fuel_common_name || ' ' year"
      else
        update_all "type_fuel_year_name = CONCAT(type_name, ' ', fuel_common_name, ' ', year)"
      end
    end
    
    process "Calculate number of vehicles from total travel percent and AutomobileTypeFuelYear" do
      AutomobileTypeFuelYear.run_data_miner!
      AutomobileTypeFuelYearAge.all.each do |record|
        record.vehicles = record.total_travel_percent * record.type_fuel_year.total_travel / record.annual_distance
        record.save
      end
    end
    
    %w{ type_name fuel_common_name type_fuel_year_name}.each do |attribute|
      verify "#{attribute.humanize} should never be missing" do
        AutomobileTypeFuelYearAge.all.each do |record|
          value = record.send(:"#{attribute}")
          unless value.present?
            raise "Missing #{attribute.humanize.downcase} for AutomobileTypeFuelYearAge '#{record.name}'"
          end
        end
      end
    end
    
    verify "Year should be 2008" do
      AutomobileTypeFuelYearAge.all.each do |record|
        value = record.send(:year)
        unless value == 2008
          raise "Invalid year for AutomobileTypeFuelYearAge '#{record.name}': #{value} (should be 2008)"
        end
      end
    end
    
    [["age", 0, 30], ["total_travel_percent", 0, 1]].each do |triplet|
      attribute = triplet[0]
      min = triplet[1]
      max = triplet[2]
      verify "#{attribute.humanize} should be from #{min} to #{max}" do
        AutomobileTypeFuelYearAge.all.each do |record|
          value = record.send(:"#{attribute}")
          unless value >= min and value <= max
            raise "Invalid #{attribute.humanize.downcase} for AutomobileTypeFuelYearAge '#{record.name}': #{value} (should be from #{min} to #{max})"
          end
        end
      end
    end
    
    %w{ annual_distance vehicles }.each do |attribute|
      verify "#{attribute.humanize} should be greater than zero" do
        AutomobileTypeFuelYearAge.all.each do |record|
          value = record.send(:"#{attribute}")
          unless value > 0
            raise "Invalid #{attribute.humanize.downcase} for AutomobileTypeFuelYearAge '#{record.name}': #{value} (should be > 0)"
          end
        end
      end
    end
    
    verify "Annual distance units should be kilometres" do
      AutomobileTypeFuelYearAge.all.each do |record|
        units = record.send(:annual_distance_units)
        unless units == "kilometres"
          raise "Invalid annual distance units for AutomobileTypeFuelYearAge '#{record.name}': #{units} (should be kilometres)"
        end
      end
    end
  end
end
