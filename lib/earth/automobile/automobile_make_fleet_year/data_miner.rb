AutomobileMakeFleetYear.class_eval do
  data_miner do
    schema :options => 'ENGINE=InnoDB default charset=utf8' do
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
  end
end

