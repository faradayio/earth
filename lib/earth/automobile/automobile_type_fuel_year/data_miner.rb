require 'earth/fuel/data_miner'
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
      where(:total_travel_units => 'billion_miles').update_all(%{
        total_travel = 1.0 * total_travel * #{conversion_factor},
        total_travel_units = 'kilometres'
      })
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
      # FIXME TODO tried to do this with arel but '*' method is not defined
      # fuel_years = arel_table
      # year_controls = AutomobileTypeFuelYearControl.arel_table
      # controls = AutomobileTypeFuelControl.arel_table
      # year_controls.project((year_controls[:total_travel_percent] * controls[:ch4_emission_factor]).sum)
      #   .join(controls)
      #   .on(year_controls[:type_name].eq(controls[:type_name])
      #   .and(year_controls[:fuel_common_name].eq(controls[:fuel_common_name]))
      #   .and(year_controls[:control_name].eq(controls[:control_name])))
      %w{ ch4 n2o }.each do |gas|
        emission_factor = %{
          ( SELECT SUM(1.0 * t1.total_travel_percent * t2.#{gas}_emission_factor)
            FROM #{AutomobileTypeFuelYearControl.quoted_table_name} AS t1
            INNER JOIN #{AutomobileTypeFuelControl.quoted_table_name} AS t2
              ON t1.type_name = t2.type_name
              AND t1.fuel_common_name = t2.fuel_common_name
              AND t1.control_name = t2.control_name
            WHERE
              t1.type_name = #{quoted_table_name}.type_name
              AND t1.fuel_common_name = #{quoted_table_name}.fuel_common_name
              AND t1.year = #{quoted_table_name}.year )
        }
        update_all(%{
          #{gas}_emission_factor = 1.0 * #{emission_factor} * total_travel / fuel_consumption,
          #{gas}_emission_factor_units = 'kilograms_per_litre'
        })
      end
    end
  end
end
