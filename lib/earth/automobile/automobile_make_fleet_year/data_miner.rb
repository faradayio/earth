AutomobileMakeFleetYear.class_eval do
  data_miner do
    schema Earth.database_options do
      string   'name'
      string   'make_year_name'
      string   'make_name'
      string   'fleet'
      integer  'year'
      float    'fuel_efficiency'
      string   'fuel_efficiency_units'
      integer  'volume'
    end

    # CAFE data privately emailed to Andy from Terry Anderson at the DOT/NHTSA
    import "annual corporate average fuel economy data for domestic and imported vehicle fleets from the NHTSA",
           :url => 'http://static.brighterplanet.com/science/data/transport/automobiles/make_fleet_years/make_fleet_years.csv',
           :errata => 'http://static.brighterplanet.com/science/data/transport/automobiles/make_fleet_years/errata.csv',
           :select => lambda { |row| row['volume'].to_i > 0 } do
      key   'name', :synthesize => lambda { |row| [ row['manufacturer_name'], row['year_content'], row['fleet'][2,2] ].join ' ' }
      store 'make_year_name', :synthesize => lambda { |row| [ row['manufacturer_name'], row['year_content'] ].join ' ' }
      store 'make_name', :field_name => 'manufacturer_name'
      store 'year', :field_name => 'year_content'
      store 'fleet', :chars => 2..3 # zero-based
      store 'fuel_efficiency', :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
      store 'volume'
    end
    
    verify "Year should be between 1978 and 2007" do
      AutomobileMakeFleetYear.all.each do |fleet_year|
        unless fleet_year.year > 1977 and fleet_year.year < 2008
          raise "Invalid year for AutomobileMakeFleetYear #{fleet_year.name}: #{fleet_year.year} (should be between 1978 and 2007)"
        end
      end
    end
    
    verify "Fuel efficiency should be greater than zero" do
      AutomobileMakeFleetYear.all.each do |fleet_year|
        unless fleet_year.fuel_efficiency > 0
          raise "Invalid fuel efficiency for AutomobileMakeFleetYear #{fleet_year.name}: #{fleet_year.fuel_efficiency} (should be > 0)"
        end
      end
    end
    
    verify "Fuel efficiency units should be kilometres per litre" do
      AutomobileMakeFleetYear.all.each do |fleet_year|
        unless fleet_year.fuel_efficiency_units == "kilometres_per_litre"
          raise "Invalid fuel efficiency units for AutomobileMakeFleetYear #{fleet_year.name}: #{fleet_year.fuel_efficiency_units} (should be kilometres_per_litre)"
        end
      end
    end
    
    verify "Volume should be greater than zero" do
      AutomobileMakeFleetYear.all.each do |fleet_year|
        unless fleet_year.volume > 0
          raise "Invalid volume for AutomobileMakeFleetYear #{fleet_year.name}: #{fleet_year.volume} (should be > 0)"
        end
      end
    end
  end
end
