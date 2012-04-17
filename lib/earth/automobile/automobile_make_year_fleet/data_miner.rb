require 'earth/fuel/data_miner'
AutomobileMakeYearFleet.class_eval do
  data_miner do
    import "annual corporate average fuel economy data for domestic and imported vehicle fleets from the NHTSA",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEdXWXB6dkVLWkowLXhYSFVUT01sS2c&output=csv',
           :errata => { :url => "file://#{Earth::ERRATA_DIR}/automobile_make_year_fleet/cafe_errata.csv", :encoding => 'ISO-8859-1' },
           :select => proc { |row| row['volume'].to_i > 0 } do
      key   'name', :synthesize => proc { |row| [ row['manufacturer_name'], row['year_content'], row['fleet'][2,2] ].join ' ' }
      store 'make_name', :field_name => 'manufacturer_name'
      store 'year', :field_name => 'year_content'
      store 'fleet', :chars => 2..3 # zero-based
      store 'fuel_efficiency', :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
      store 'volume'
    end
  end
end
