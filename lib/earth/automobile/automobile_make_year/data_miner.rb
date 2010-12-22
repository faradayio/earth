AutomobileMakeYear.class_eval do
  data_miner do
    process "Start from scratch" do
      connection.drop_table table_name
    end
    
    schema Earth.database_options do
      string   'name'
      string   'make_name'
      integer  'year'
      float    'fuel_efficiency'
      string   'fuel_efficiency_units'
      integer  'volume'
    end

    process "Derive manufacturer names and years from automobile make fleet years" do
      AutomobileMakeFleetYear.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO automobile_make_years(name, make_name, year)
        SELECT
          automobile_make_fleet_years.make_year_name,
          automobile_make_fleet_years.make_name,
          automobile_make_fleet_years.year
        FROM automobile_make_fleet_years
      }
    end
    
    process "Derive annual corporate average fuel economy across all vehicles from automobile make fleet years" do
      AutomobileMakeFleetYear.run_data_miner!
      make_fleet_years = AutomobileMakeFleetYear.arel_table
      make_years = AutomobileMakeYear.arel_table
      conditional_relation = make_years[:name].eq(make_fleet_years[:make_year_name])
      relation = AutomobileMakeFleetYear.weighted_average_relation(:fuel_efficiency, :weighted_by => :volume).where(conditional_relation)
      update_all "fuel_efficiency = (#{relation.to_sql})"
      update_all "fuel_efficiency_units = 'kilometres_per_litre'"
    end
    
    process "Derive sales volume across all vehicles from automobile make fleet years" do
      connection.execute %{
        UPDATE automobile_make_years SET automobile_make_years.volume = (SELECT SUM(automobile_make_fleet_years.volume) FROM automobile_make_fleet_years WHERE automobile_make_fleet_years.make_year_name = automobile_make_years.name)
      }
    end
    
    verify "Year should be between 1978 and 2007" do
      AutomobileMakeYear.all.each do |make_year|
        unless make_year.year > 1977 and make_year.year < 2008
          raise "Invalid year for AutomobileMakeYear #{make_year.name}: #{make_year.year} (should be between 1978 and 2007)"
        end
      end
    end
    
    verify "Fuel efficiency should be greater than zero" do
      AutomobileMakeYear.all.each do |make_year|
        unless make_year.fuel_efficiency > 0
          raise "Invalid fuel efficiency for AutomobileMakeYear #{make_year.name}: #{make_year.fuel_efficiency} (should be > 0)"
        end
      end
    end
    
    verify "Fuel efficiency units should be kilometres per litre" do
      AutomobileMakeYear.all.each do |make_year|
        unless make_year.fuel_efficiency_units == "kilometres_per_litre"
          raise "Invalid fuel efficiency units for AutomobileMakeYear #{make_year.name}: #{make_year.fuel_efficiency_units} (should be kilometres_per_litre)"
        end
      end
    end
    
    verify "Volume should be greater than zero" do
      AutomobileMakeYear.all.each do |make_year|
        unless make_year.volume > 0
          raise "Invalid volume for AutomobileMakeYear #{make_year.name}: #{make_year.volume} (should be > 0)"
        end
      end
    end
  end
end
