AutomobileTypeFuelYear.class_eval do
  data_miner do
    import "total vehicle miles travelled by gasoline passenger cars from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-87.csv',
           :skip => 1,
           :select => lambda { |row| row['Year'].to_i.to_s == row['Year'] } do
      key   'name', :synthesize => lambda { |row| "Passenger cars gasoline #{row['Year']}" }
      store 'type_name', :static => 'Passenger cars'
      store 'fuel_common_name', :static => 'gasoline'
      store 'year', :field_name => 'Year'
      store 'total_travel', :field_name => 'Passenger Cars', :units => :billion_miles
    end
    
    import "total vehicle miles travelled by gasoline light-duty trucks from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-87.csv',
           :skip => 1,
           :select => lambda { |row| row['Year'].to_i.to_s == row['Year'] } do
      key   'name', :synthesize => lambda { |row| "Light-duty trucks gasoline #{row['Year']}" }
      store 'type_name', :static => 'Light-duty trucks'
      store 'fuel_common_name', :static => 'gasoline'
      store 'year', :field_name => 'Year'
      store 'total_travel', :field_name => 'Light-Duty Trucks', :units => :billion_miles
    end
    
    import "total vehicle miles travelled by diesel passenger cars from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-88.csv',
           :skip => 1,
           :select => lambda { |row| row['Year'].to_i.to_s == row['Year'] } do
      key   'name', :synthesize => lambda { |row| "Passenger cars diesel #{row['Year']}" }
      store 'type_name', :static => 'Passenger cars'
      store 'fuel_common_name', :static => 'diesel'
      store 'year', :field_name => 'Year'
      store 'total_travel', :field_name => 'Passenger Cars', :units => :billion_miles
    end
    
    import "total vehicle miles travelled by diesel light-duty trucks from the 2010 EPA GHG Inventory",
           :url => 'http://www.epa.gov/climatechange/emissions/downloads10/2010-Inventory-Annex-Tables.zip',
           :filename => 'Annex Tables/Annex 3/Table A-88.csv',
           :skip => 1,
           :select => lambda { |row| row['Year'].to_i.to_s == row['Year'] } do
      key   'name', :synthesize => lambda { |row| "Light-duty trucks diesel #{row['Year']}" }
      store 'type_name', :static => 'Light-duty trucks'
      store 'fuel_common_name', :static => 'diesel'
      store 'year', :field_name => 'Year'
      store 'total_travel', :field_name => 'Light-Duty Trucks', :units => :billion_miles
    end
    
    process "Convert total travel from billion miles to kilometres" do
      conversion_factor = 1_000_000_000.miles.to(:kilometres)
      connection.execute %{
        UPDATE automobile_type_fuel_years
        SET total_travel = 1.0 * total_travel * #{conversion_factor},
            total_travel_units = 'kilometres'
        WHERE total_travel_units = 'billion_miles'
      }
    end
    
    import "fuel consumption derived from the 2010 EPA GHG Inventory",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHBCMFhLRTFTZENsd0dPUGUyYlJna0E&hl=en&gid=0&output=csv' do
      key 'name'
      store 'fuel_consumption', :units_field_name => 'fuel_consumption_units'
    end
    
    process "Derive type year name for association with AutomobileTypeYear" do
      update_all "type_year_name = type_name || ' ' || year"
    end
    
    process "Ensure AutomobileTypeFuelYearControl and AutomobileTypeFuelControl are populated" do
      AutomobileTypeFuelYearControl.run_data_miner!
      AutomobileTypeFuelControl.run_data_miner!
    end
    
    process "Calculate CH4 and N2O emision factors from AutomobileTypeFuelYearControl and AutomobileTypeFuelControl" do
      AutomobileTypeFuelYear.all.each do |record|
        record.ch4_emission_factor = record.year_controls.map do |year_control|
          year_control.total_travel_percent.to_f * year_control.control.ch4_emission_factor
        end.sum * record.total_travel / record.fuel_consumption
        
        record.n2o_emission_factor = record.year_controls.map do |year_control|
          year_control.total_travel_percent.to_f * year_control.control.n2o_emission_factor
        end.sum * record.total_travel / record.fuel_consumption
        
        record.ch4_emission_factor_units = 'kilograms_per_litre'
        record.n2o_emission_factor_units = 'kilograms_per_litre'
        
        record.save!
      end
    end
  end
end
