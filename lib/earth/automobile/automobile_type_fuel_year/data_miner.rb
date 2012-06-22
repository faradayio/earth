AutomobileTypeFuelYear.class_eval do
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    [['gasoline', 'G'], ['diesel', 'D']].each do |fuel, fuel_code|
      [['Passenger cars', 'V'], ['Light-duty trucks', 'T']].each do |type, type_code|
        code = "LD" + fuel_code + type_code
        
        import "age distribution of #{fuel} #{type.downcase} from the 2011 EPA GHG Inventory",
               :url => 'http://www.epa.gov/climatechange/emissions/downloads11/Annex%20Tables.zip',
               :filename => 'Annex Tables/Table A-93.csv',
               :skip => 1,
               :headers => %w{ age LDGV LDGT HDGV LDDV LDDT HDDT MC },
               :select => proc { |row| row['age'].to_i.to_s == row['age'] } do
          key 'name', :synthesize => proc { |row| "#{type} #{fuel} #{2009 - row['age'].to_i}" }
          store 'type_name', :static => type
          store 'fuel_family', :static => fuel
          store 'year', :synthesize => proc { |row| 2009 - row['age'].to_i }
          store 'share_of_type', :synthesize => proc { |row| row[code].to_f / (code == 'LDDV' ? 57.5 : 100) } # total percent only sums to 57.5 for diesel cars
        end
        
        import "average distance per vehicle for gasoline passenger cars from the 2011 EPA GHG Inventory",
               :url => 'http://www.epa.gov/climatechange/emissions/downloads11/Annex%20Tables.zip',
               :filename => 'Annex Tables/Table A-94.csv',
               :skip => 1,
               :headers => %w{ age LDGV LDGT HDGV LDDV LDDT HDDT MC },
               :select => proc { |row| row['age'].to_i.to_s == row['age'] } do
          key 'name', :synthesize => proc { |row| "#{type} #{fuel} #{2009 - row['age'].to_i}" }
          store 'annual_distance', :field_name => code, :from_units => :miles, :to_units => :kilometres
        end
      end
    end
    
    process "Ensure AutomobileTypeFuelYearControl is populated" do
      AutomobileTypeFuelYearControl.run_data_miner!
    end
    
    # Can't use an update all here b/c efs are methods defined on ATFYC that look up the ef from ATFC
    process "Derive ch4 and n2o emission factor from AutomobileTypeFuelYearControl" do
      safe_find_each do |atfy|
        atfy.update_attributes!(
          :ch4_emission_factor => atfy.type_fuel_year_controls.sum{ |atfyc| atfyc.total_travel_percent * atfyc.ch4_emission_factor },
          :n2o_emission_factor => atfy.type_fuel_year_controls.sum{ |atfyc| atfyc.total_travel_percent * atfyc.n2o_emission_factor },
          :ch4_emission_factor_units => atfy.type_fuel_year_controls.first.ch4_emission_factor_units,
          :n2o_emission_factor_units => atfy.type_fuel_year_controls.first.n2o_emission_factor_units
        )
      end
    end
  end
end
