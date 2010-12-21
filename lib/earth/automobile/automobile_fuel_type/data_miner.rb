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
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdDlqeU9vQkVkNG1NZXV4WklKTjJkU3c&hl=en&single=true&gid=0&output=csv' do
      key   'code'
      store 'name'
      store 'annual_distance', :units_field_name => 'annual_distance_units'
      store 'emission_factor', :units_field_name => 'emission_factor_units'
    end
    
    verify "Annual distance should be greater than zero" do
      AutomobileFuelType.all.each do |fuel_type|
        unless fuel_type.annual_distance > 0.0
          raise "Invalid annual_distance for AutomobileFuelType #{fuel_type.name}: #{fuel_type.annual_distance} (should be > 0)"
        end
      end
    end
    
    verify "Annual distance units should never be missing" do
      AutomobileFuelType.all.each do |fuel_type|
        if fuel_type.annual_distance_units.nil?
          raise "Missing annual distance units for AutomobileFuelType #{fuel_type.name}"
        end
      end
    end
    
    verify "Emission factor should be zero or more" do
      AutomobileFuelType.all.each do |fuel_type|
        unless fuel_type.emission_factor >= 0.0
          raise "Invalid emission_factor for AutomobileFuelType #{fuel_type.name}: #{fuel_type.emission_factor} (should be >= 0)"
        end
      end
    end
    
    verify "Emission factor units should never be missing" do
      AutomobileFuelType.all.each do |fuel_type|
        if fuel_type.emission_factor_units.nil?
          raise "Missing emission factor units for AutomobileFuelType #{fuel_type.name}"
        end
      end
    end
  end
end
