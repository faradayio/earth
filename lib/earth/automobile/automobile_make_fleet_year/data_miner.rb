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
    
    import "annual corporate average fuel economy data for domestic and imported vehicle fleets from the NHTSA",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEdXWXB6dkVLWkowLXhYSFVUT01sS2c&hl=en&gid=0&output=csv',
           :errata => { 'url' => 'http://static.brighterplanet.com/science/data/transport/automobiles/make_fleet_years/errata.csv' },
           :select => lambda { |row| row['volume'].to_i > 0 } do
      key   'name', :synthesize => lambda { |row| [ row['manufacturer_name'], row['year_content'], row['fleet'][2,2] ].join ' ' }
      store 'make_year_name', :synthesize => lambda { |row| [ row['manufacturer_name'], row['year_content'] ].join ' ' }
      store 'make_name', :field_name => 'manufacturer_name'
      store 'year', :field_name => 'year_content'
      store 'fleet', :chars => 2..3 # zero-based
      store 'fuel_efficiency', :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
      store 'volume'
    end
    
    verify "Year should be from 1978 to 2010" do
      AutomobileMakeFleetYear.find_by_sql("SELECT DISTINCT year FROM automobile_make_fleet_years").map(&:year).each do |year|
        unless year > 1977 and year < 2011
          raise "Invalid year in automobile_make_fleet_years: #{year} is not from 1978 to 2010"
        end
      end
    end
    
    verify "Fuel efficiency and volume should be greater than zero" do
      [:fuel_efficiency, :volume].each do |field|
        if AutomobileMakeFleetYear.where(field => nil).any?
          raise "Invalid #{field} in automobile_make_fleet_years: nil is not > 0"
        else
          min = AutomobileMakeFleetYear.minimum(field)
          unless min > 0
            raise "Invalid #{field} in automobile_make_fleet_years: #{min} is not > 0"
          end
        end
      end
    end
    
    verify "Fuel efficiency units should be kilometres per litre" do
      AutomobileMakeFleetYear.find_by_sql("SELECT DISTINCT fuel_efficiency_units FROM automobile_make_fleet_years").map(&:fuel_efficiency_units).each do |units|
        unless units == "kilometres_per_litre"
          raise "Invalid fuel efficiency units in automobile_make_fleet_years: #{units} is not 'kilometres_per_litre'"
        end
      end
    end
  end
end
