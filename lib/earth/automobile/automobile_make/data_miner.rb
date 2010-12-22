AutomobileMake.class_eval do
  data_miner do
    process "Start from scratch" do
      connection.drop_table table_name
    end
    
    schema Earth.database_options do
      string  'name'
      boolean 'major'
      float   'fuel_efficiency'
      string  'fuel_efficiency_units'
    end

    process "Derive manufacturer names from automobile make fleet years" do
      AutomobileMakeFleetYear.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO automobile_makes(name)
        SELECT DISTINCT automobile_make_fleet_years.make_name FROM automobile_make_fleet_years
      }
    end
    
    import "a Brighter-Planet defined list of major automobile manufacturers",
           :url => 'http://static.brighterplanet.com/science/data/transport/automobiles/makes/make_importance.csv' do
      key 'name'
      store 'major'
    end
    
    process "Derive average fuel efficiency from automobile make fleet years" do
      AutomobileMakeFleetYear.run_data_miner!
      make_fleet_years = AutomobileMakeFleetYear.arel_table
      makes = AutomobileMake.arel_table
      conditional_relation = makes[:name].eq(make_fleet_years[:make_name])
      relation = AutomobileMakeFleetYear.weighted_average_relation(:fuel_efficiency, :weighted_by => :volume).where(conditional_relation)
      update_all "fuel_efficiency = (#{relation.to_sql})"
      update_all "fuel_efficiency_units = 'kilometres_per_litre'"
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
