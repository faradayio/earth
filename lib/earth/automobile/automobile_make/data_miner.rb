AutomobileMake.class_eval do
  data_miner do
    process "Start from scratch" do
      connection.drop_table table_name
    end
    
    schema Earth.database_options do
      string  'name'
      float   'fuel_efficiency'
      string  'fuel_efficiency_units'
    end
    
    process "Derive manufacturer names from automobile make model year variants" do
      AutomobileMakeModelYearVariant.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO automobile_makes(name)
        SELECT DISTINCT automobile_make_model_year_variants.make_name
        FROM automobile_make_model_year_variants
      }
    end
    
    # sabshere 1/31/11 add Avanti, DaimlerChrysler, IHC, Tesla, etc.
    process "Derive extra manufacturer names from CAFE data" do
      AutomobileMakeFleetYear.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO automobile_makes(name)
        SELECT DISTINCT automobile_make_fleet_years.make_name
        FROM automobile_make_fleet_years
      }
    end
    
    process "Calculate fuel efficiency from automobile make fleet years for makes with CAFE data" do
      AutomobileMakeFleetYear.run_data_miner!
      make_fleet_years = AutomobileMakeFleetYear.arel_table
      makes = AutomobileMake.arel_table
      conditional_relation = makes[:name].eq(make_fleet_years[:make_name])
      relation = AutomobileMakeFleetYear.weighted_average_relation(:fuel_efficiency, :weighted_by => :volume).where(conditional_relation)
      update_all "fuel_efficiency = (#{relation.to_sql})"
      update_all "fuel_efficiency_units = 'kilometres_per_litre'"
    end
    
    process "Calculate fuel effeciency from automobile make model year variants for makes without CAFE data" do
      connection.execute %{
        UPDATE automobile_makes
        SET automobile_makes.fuel_efficiency = (SELECT AVG(automobile_make_model_year_variants.fuel_efficiency) FROM automobile_make_model_year_variants WHERE automobile_makes.name = automobile_make_model_year_variants.make_name)
        WHERE automobile_makes.fuel_efficiency IS NULL
      }
      connection.execute %{
        UPDATE automobile_makes
        SET automobile_makes.fuel_efficiency_units = 'kilometres_per_litre'
        WHERE automobile_makes.fuel_efficiency_units IS NULL
      }
    end
    
    verify "Fuel efficiency should be greater than zero" do
      AutomobileMake.all.each do |make|
        unless make.fuel_efficiency > 0
          raise "Invalid fuel efficiency for AutomobileMake #{make.name}: #{make.fuel_efficiency} (should be > 0)"
        end
      end
    end
    
    verify "Fuel efficiency units should be kilometres per litre" do
      AutomobileMake.all.each do |make|
        unless make.fuel_efficiency_units == "kilometres_per_litre"
          raise "Invalid fuel efficiency units for AutomobileMake #{make.name}: #{make.fuel_efficiency_units} (should be kilometres_per_litre)"
        end
      end
    end
  end
end

# leave this for later if we need it
# SUBSIDIARIES = {
#   'Chevrolet' => 'GM',
#   'Pontiac' => 'GM',
#   'Audi' => 'Volkswagen',
#   'Dodge' => 'Chrysler',
#   'Lincoln' => 'Ford',
#   'Plymouth' => 'Chrysler',
#   'Buick' => 'GM',
#   'Cadillac' => 'GM',
#   'Merkur' => 'Ford',
#   'Oldsmobile' => 'GM',
#   'GMC' => 'GM',
#   'Bentley' => 'Rolls-Royce', # currently owned by Volkswagen, but a Flying Spur is hardly a rebranded Passat
#   'Acura' => 'Honda',
#   'Land Rover' => 'Ford',
#   'Eagle' => 'Chrysler',
#   'Geo' => 'GM',
#   'Laforza' => 'Ford',
#   'Infiniti' => 'Nissan',
#   'Lexus' => 'Toyota',
#   'Saturn' => 'GM',
#   'Mercury' => 'Ford',
#   'Alpina' => 'BMW',
#   'Mini' => 'BMW',
#   'Maybach' => 'Mercedes',
#   'Hummer' => 'GM'
# }
