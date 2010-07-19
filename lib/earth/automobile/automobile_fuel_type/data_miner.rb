AutomobileFuelType.class_eval do
  data_miner do
    schema Earth.database_options do
      string   'code'
      string   'name'
      float    'emission_factor'
      string   'emission_factor_units'
      float    'annual_distance'
      string   'annual_distance_units'
    end
    
    import("the fuels used in the 2000 EPA fuel economy guide",
           :url => 'http://www.fueleconomy.gov/FEG/epadata/00data.zip',
           :filename => 'Gd6-dsc.txt',
           :format => :fixed_width,
           :crop => 21..26, # inclusive
           :cut => '2-',
           :select => lambda { |row| /\A[A-Z]/.match row[:code] },
           :schema => [[ 'code',   2,  { :type => :string }  ],
                       [ 'spacer', 2 ],
                       [ 'name',   52, { :type => :string } ]]) do
      key   'code'
      store 'name'
    end

    import "a pre-calculated emission factor and average annual distance for each fuel",
           :url => 'http://static.brighterplanet.com/science/data/transport/automobiles/models_export/automobile_fuel_type.csv' do
      key   'code', :field_name => 'code'
      store 'name'
      store 'annual_distance', :units => :kilometres
      store 'emission_factor', :units => :kilograms_per_litre
    end

    # pull electricity emission factor from residential electricity
    import "a pre-calculated emission factor for electricity",
           :url => 'http://spreadsheets.google.com/pub?key=rukxnmuhhsOsrztTrUaFCXQ',
           :select => lambda { |row| row['name'] == 'electricity' } do
      key 'name'
      store 'emission_factor', :units => :kilograms_per_litre
    end
    
    # still need distance estimate for electric cars
  end
end

