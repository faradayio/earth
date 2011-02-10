AutomobileTypeFuelYear.class_eval do
  data_miner do
    schema Earth.database_options do
      string  'name'
      string  'type_name'
      string  'fuel_common_name'
      integer 'year'
      float   'total_travel'
      string  'total_travel_units'
      float   'fuel_consumption'
      string  'fuel_consumption_units'
      float   'ch4_emission_factor'
      string  'ch4_emission_factor_units'
      float   'n2o_emission_factor'
      string  'n2o_emission_factor_units'
      float   'hfc_emission_factor'
      string  'hfc_emission_factor_units'
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
    
    import "fuel consumption derived from the 2010 EPA GHG Inventory",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHBCMFhLRTFTZENsd0dPUGUyYlJna0E&hl=en&output=csv' do
      key 'name'
      store 'fuel_consumption', :units_field_name => 'fuel_consumption_units'
    end
    
    # FIXME TODO maybe make this a method on AutomobileTypeFuelYear?
    process "Calculate CH4 and N2O emision factors from AutomobileTypeFuelYearControl and AutomobileTypeFuelControl" do
      AutomobileTypeFuelYearControl.run_data_miner!
      AutomobileTypeFuelControl.run_data_miner!
      
      year_controls = AutomobileTypeFuelYearControl.arel_table
      controls = AutomobileTypeFuelControl.arel_table
      years = AutomobileTypeFuelYear.arel_table
      
      join_relation = controls[:type_name].eq(year_controls[:type_name]).and(controls[:fuel_common_name].eq(year_controls[:fuel_common_name])).and(controls[:control_name].eq(year_controls[:control_name]))
      where_relation = year_controls[:type_name].eq(years[:type_name]).and(year_controls[:fuel_common_name].eq(years[:fuel_common_name])).and(year_controls[:year].eq(years[:year]))
      
      %w{ ch4 n2o }.each do |gas|
        update_all "#{gas}_emission_factor = (
          SELECT SUM(automobile_type_fuel_year_controls.total_travel_percent * automobile_type_fuel_controls.#{gas}_emission_factor)
          FROM automobile_type_fuel_year_controls
          INNER JOIN automobile_type_fuel_controls
          ON #{join_relation.to_sql}
          WHERE #{where_relation.to_sql}) * total_travel / fuel_consumption"
        update_all "#{gas}_emission_factor_units = 'kilograms_per_litre'"
      end
    end
    
    # FIXME TODO maybe make this a method on AutomobileTypeFuelYear?
    process "Calculate HFC emission factor from AutomobileTypeYear" do
      AutomobileTypeYear.run_data_miner!
      type_fuel_years = AutomobileTypeFuelYear.arel_table
      type_years = AutomobileTypeYear.arel_table
      
      AutomobileTypeFuelYear.all.each do |record|
        fuel_consumption = AutomobileTypeFuelYear.find_all_by_type_name_and_year(record.type_name, record.year).map{|x| x.fuel_consumption}.sum
        hfc_emissions_sql = type_years.project(type_years[:hfc_emissions]).where(type_years[:type_name].eq(record.type_name).and(type_years[:year].eq(record.year))).to_sql
        connection.execute "UPDATE automobile_type_fuel_years SET hfc_emission_factor = ((#{hfc_emissions_sql}) / #{fuel_consumption}) WHERE type_name = '#{record.type_name}' AND year = #{record.year}"
      end
      update_all "hfc_emission_factor_units = 'kilograms_co2e_per_litre'"
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
    
    verify "Year should be from 1990 to 2008" do
      AutomobileTypeFuelYear.all.each do |record|
        year = record.send(:year)
        unless year > 1989 and year < 2009
          raise "Invalid year for AutomobileTypeFuelYear '#{record.name}': #{year} (should be from 1990 to 2008)"
        end
      end
    end
    
    verify "Total travel, fuel consumption, and emission factors should be greater than zero" do
      AutomobileTypeFuelYear.all.each do |record|
        %w{ total_travel fuel_consumption ch4_emission_factor n2o_emission_factor }.each do |attribute|
          value = record.send(:"#{attribute}")
          unless value > 0
            raise "Invalid #{attribute} for AutomobileTypeFuelYear '#{record.name}': #{value} (should be > 0)"
          end
        end
      end
    end
    
    verify "HFC emission factor should be zero or more" do
      AutomobileTypeFuelYear.all.each do |record|
        value = record.send(:hfc_emission_factor)
        unless value >= 0
          raise "Invalid HFC emission factor for AutomobileTypeFuelYear '#{record.name}': #{value} (should be >= 0)"
        end
      end
    end
    
    verify "Units should be correct" do
      AutomobileTypeFuelYear.all.each do |record|
        ["total_travel_units kilometres", "fuel_consumption_units litres", "ch4_emission_factor_units kilograms_per_litre", "n2o_emission_factor_units kilograms_per_litre", "hfc_emission_factor_units kilograms_co2e_per_litre"].each do |pair|
          attribute = pair.split[0]
          proper_units = pair.split[1]
          units = record.send(:"#{attribute}")
          unless units == proper_units
            raise "Invalid #{attribute} for AutomobileTypeFuelYear '#{record.name}': #{units} (should be #{proper_units})"
          end
        end
      end
    end
  end
end
