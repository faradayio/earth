AutomobileActivityYearTypeFuel.class_eval do
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    ['Passenger cars', 'Light-duty trucks'].each do |type|
      import "annual vehicle miles travelled by gasoline #{type.downcase} from the 2011 EPA GHG Inventory",
             :url => 'http://www.epa.gov/climatechange/emissions/downloads11/Annex%20Tables.zip',
             :filename => 'Annex Tables/Table A-89.csv',
             :skip => 1,
             :headers => ['Year', 'Passenger cars', 'Light-duty trucks', 'ignore', 'ignore'],
             :select => proc { |row| row['Year'].to_i.to_s == row['Year'] } do
        key   'name', :synthesize => proc { |row| "#{row['Year']} #{type} gasoline" }
        store 'activity_year', :field_name => 'Year'
        store 'type_name', :static => type
        store 'fuel_common_name', :static => 'gasoline'
        store 'distance', :field_name => type, :from_units => :billion_miles, :to_units => :kilometres
      end
      
      import "annual vehicle miles travelled by diesel #{type.downcase} from the 2011 EPA GHG Inventory",
             :url => 'http://www.epa.gov/climatechange/emissions/downloads11/Annex%20Tables.zip',
             :filename => 'Annex Tables/Table A-90.csv',
             :skip => 1,
             :headers => ['Year', 'Passenger cars', 'Light-duty trucks', 'ignore', 'ignore'],
             :select => proc { |row| row['Year'].to_i.to_s == row['Year'] } do
        key   'name', :synthesize => proc { |row| "#{row['Year']} #{type} diesel" }
        store 'activity_year', :field_name => 'Year'
        store 'type_name', :static => type
        store 'fuel_common_name', :static => 'diesel'
        store 'distance', :field_name => type, :from_units => :billion_miles, :to_units => :kilometres
      end
      
      # import "annual vehicle miles travelled by alternative fuel #{type.downcase} from the 2011 EPA GHG Inventory",
      #        :url => 'http://www.epa.gov/climatechange/emissions/downloads11/Annex%20Tables.zip',
      #        :filename => 'Annex Tables/Table A-91.csv',
      #        :skip => 1,
      #        :headers => ['Year', 'Passenger cars', 'Light-duty trucks', 'ignore', 'ignore'],
      #        :select => proc { |row| row['Year'].to_i.to_s == row['Year'] } do
      #   key   'name', :synthesize => proc { |row| "#{row['Year']} #{type} alternative" }
      #   store 'activity_year', :field_name => 'Year'
      #   store 'type_name', :static => type
      #   store 'fuel_common_name', :static => 'alternative'
      #   store 'distance', :field_name => type, :from_units => :billion_miles, :to_units => :kilometres
      # end
    end
    
    import "fuel consumption derived from 2012 EPA GHG Inventory",
           :url => "file://#{Earth::DATA_DIR}/automobile/annual_fuel_consumption.csv" do
      key   'name'
      store 'activity_year'
      store 'type_name'
      store 'fuel_common_name'
      store 'fuel_consumption', :from_units => :million_gallons, :to_units => :litres
    end
  end
end
