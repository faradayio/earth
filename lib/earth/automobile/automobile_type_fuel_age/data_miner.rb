# DEPRECATED - use AutomobileTypeFuelYearAge
AutomobileTypeFuelAge.class_eval do
  data_miner do
    import "age distribution of gasoline passenger cars from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-91.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Passenger cars gasoline age #{row['Vehicle Age']}" }
      store 'type_name', :static => 'Passenger cars'
      store 'fuel_common_name', :static => 'gasoline'
      store 'age', :field_name => 'Vehicle Age'
      store 'age_percent', :synthesize => lambda { |row| row['LDGV'].to_f / 100 }
    end
    
    import "age distribution of gasoline light-duty trucks from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-91.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Light-duty trucks gasoline age #{row['Vehicle Age']}" }
      store 'type_name', :static => 'Light-duty trucks'
      store 'fuel_common_name', :static => 'gasoline'
      store 'age', :field_name => 'Vehicle Age'
      store 'age_percent', :synthesize => lambda { |row| row['LDGT'].to_f / 100 }
    end
    
    import "age distribution of diesel passenger cars from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-91.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Passenger cars diesel age #{row['Vehicle Age']}" }
      store 'type_name', :static => 'Passenger cars'
      store 'fuel_common_name', :static => 'diesel'
      store 'age', :field_name => 'Vehicle Age'
      store 'age_percent', :synthesize => lambda { |row| row['LDDV'].to_f / 100 }
    end
    
    import "age distribution of diesel light-duty trucks from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-91.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Light-duty trucks diesel age #{row['Vehicle Age']}" }
      store 'type_name', :static => 'Light-duty trucks'
      store 'fuel_common_name', :static => 'diesel'
      store 'age', :field_name => 'Vehicle Age'
      store 'age_percent', :synthesize => lambda { |row| row['LDDT'].to_f / 100 }
    end
    
    import "total travel distribution of gasoline passenger cars from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-93.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Passenger cars gasoline age #{row['Vehicle Age']}" }
      store 'total_travel_percent', :synthesize => lambda { |row| row['LDGV'].to_f / 100 }
    end
    
    import "total travel distribution of gasoline light-duty trucks from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-93.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Light-duty trucks gasoline age #{row['Vehicle Age']}" }
      store 'total_travel_percent', :synthesize => lambda { |row| row['LDGT'].to_f / 100 }
    end
    
    import "total travel distribution of diesel passenger cars from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-93.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Passenger cars diesel age #{row['Vehicle Age']}" }
      store 'total_travel_percent', :synthesize => lambda { |row| row['LDDV'].to_f / 100 }
    end
    
    import "total travel distribution of diesel light-duty trucks from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-93.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Light-duty trucks diesel age #{row['Vehicle Age']}" }
      store 'total_travel_percent', :synthesize => lambda { |row| row['LDDT'].to_f / 100 }
    end
    
    import "average annual distance for gasoline passenger cars from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-92.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Passenger cars gasoline age #{row['Vehicle Age']}" }
      store 'annual_distance', :synthesize => lambda { |row| row['LDGV'].to_s.sub(',', '') }, :units => :miles
    end
    
    import "average annual distance for gasoline light-duty trucks from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-92.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Light-duty trucks gasoline age #{row['Vehicle Age']}" }
      store 'annual_distance', :synthesize => lambda { |row| row['LDGT'].to_s.sub(',', '') }, :units => :miles
    end
    
    import "average annual distance for diesel passenger cars from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-92.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Passenger cars diesel age #{row['Vehicle Age']}" }
      store 'annual_distance', :synthesize => lambda { |row| row['LDDV'].to_s.sub(',', '') }, :units => :miles
    end
    
    import "average annual distance for diesel light-duty trucks from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-92.csv',
           :skip => 1,
           :select => lambda { |row| row['Vehicle Age'].to_i.to_s == row['Vehicle Age'] } do
      key 'name', :synthesize => lambda { |row| "Light-duty trucks diesel age #{row['Vehicle Age']}" }
      store 'annual_distance', :synthesize => lambda { |row| row['LDDT'].to_s.sub(',', '') }, :units => :miles
    end
    
    process "Convert annual distance from miles to kilometres" do
      conversion_factor = 1.miles.to(:kilometres)
      update_all "annual_distance = annual_distance * #{conversion_factor}"
      update_all "annual_distance_units = 'kilometres'"
    end
    
    process "Ensure AutomobileTypeFuelYear is populated" do
      AutomobileTypeFuelYear.run_data_miner!
    end
    
    # FIXME TODO maybe make this a method on AutomobileTypeFuelAge?
    process "Calculate number of vehicles from total travel percent and AutomobileTypeFuelYear" do
      max_year = AutomobileTypeFuelYear.maximum :year
      update_all %{
        vehicles =
          ( SELECT t1.total_travel
            FROM #{AutomobileTypeFuelYear.quoted_table_name} AS t1
            WHERE
              t1.year = #{max_year}
              AND t1.type_name = #{quoted_table_name}.type_name
              AND t1.fuel_common_name = #{quoted_table_name}.fuel_common_name )
          * #{quoted_table_name}.total_travel_percent / #{quoted_table_name}.annual_distance
      }
    end
  end
end
