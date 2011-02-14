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
      integer  'volume' # This will sometimes be null because not all make_years have CAFE data
    end
    
    process "Derive manufacturer names and years from automobile make model year variants" do
      AutomobileMakeModelYearVariant.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO automobile_make_years(name, make_name, year)
        SELECT
          automobile_make_model_year_variants.make_year_name,
          automobile_make_model_year_variants.make_name,
          automobile_make_model_year_variants.year
        FROM automobile_make_model_year_variants
      }
    end
    
    # FIXME TODO make this a method on AutomobileMakeYear?
    process "Calculate fuel efficiency from make fleet years for makes with CAFE data" do
      AutomobileMakeFleetYear.run_data_miner!
      make_fleet_years = AutomobileMakeFleetYear.arel_table
      make_years = AutomobileMakeYear.arel_table
      conditional_relation = make_years[:name].eq(make_fleet_years[:make_year_name])
      relation = AutomobileMakeFleetYear.weighted_average_relation(:fuel_efficiency, :weighted_by => :volume).where(conditional_relation)
      update_all "fuel_efficiency = (#{relation.to_sql})"
      update_all "fuel_efficiency_units = 'kilometres_per_litre'"
    end
    
    process "Calculate fuel effeciency from automobile make model year variants for makes without CAFE data" do
      connection.execute %{
        UPDATE automobile_make_years
        SET automobile_make_years.fuel_efficiency = (SELECT AVG(automobile_make_model_year_variants.fuel_efficiency) FROM automobile_make_model_year_variants WHERE automobile_make_years.name = automobile_make_model_year_variants.make_year_name)
        WHERE automobile_make_years.fuel_efficiency IS NULL
      }
      connection.execute %{
        UPDATE automobile_make_years
        SET automobile_make_years.fuel_efficiency_units = 'kilometres_per_litre'
        WHERE automobile_make_years.fuel_efficiency_units IS NULL
      }
    end
    
    process "Calculate sales volume from automobile make fleet years for makes with CAFE data" do
      connection.execute %{
        UPDATE automobile_make_years SET automobile_make_years.volume = (SELECT SUM(automobile_make_fleet_years.volume) FROM automobile_make_fleet_years WHERE automobile_make_fleet_years.make_year_name = automobile_make_years.name)
      }
    end
    
    verify "Year should be from 1985 to 2010" do
      AutomobileMakeYear.all.each do |make_year|
        unless make_year.year > 1984 and make_year.year < 2011
          raise "Invalid year for AutomobileMakeYear #{make_year.name}: #{make_year.year} (should be from 1985 to 2010)"
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
  end
end
