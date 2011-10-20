AutomobileMake.class_eval do
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    process "Ensure AutomobileMakeModelYearVariant and AutomobileMakeYearFleet are populated" do
      AutomobileMakeModelYearVariant.run_data_miner!
      AutomobileMakeYearFleet.run_data_miner!
    end
    
    process "Derive manufacturer names from automobile make model year variants" do
      ::Earth::Utils.insert_ignore(
        :src => AutomobileMakeModelYearVariant,
        :dest => AutomobileMake,
        :cols => {
          :make_name => :name,
        }
      )
    end
    
    # sabshere 1/31/11 add Avanti, DaimlerChrysler, IHC, Tesla, etc.
    process "Derive extra manufacturer names from CAFE data" do
      ::Earth::Utils.insert_ignore(
        :src => AutomobileMakeYearFleet,
        :dest => AutomobileMake,
        :cols => {
          :make_name => :name,
        }
      )
    end
    
    # FIXME TODO derive units here
    process "Calculate fuel efficiency from CAFE data" do
      makes = arel_table
      year_fleets = AutomobileMakeYearFleets.arel_table
      conditional_relation = makes[:name].eq(year_fleets[:make_name])
      relation = AutomobileMakeYearFleets.weighted_average_relation(:fuel_efficiency, :weighted_by => :volume).where(conditional_relation)
      update_all("fuel_efficiency = (#{relation.to_sql}), fuel_efficiency_units = 'kilometres_per_litre'")
    end
    
    # FIXME TODO derive units here
    process "Calculate any missing fuel effeciencies from automobile make model year variants" do
      makes = arel_table
      variants = AutomobileMakeModelYearVariant.arel_table
      conditional_relation = variants[:make_name].eq(makes[:name])
      relation = variants.project(variants[:fuel_efficiency].average).where(conditional_relation)
      update_all("fuel_efficiency = (#{relation.to_sql}), fuel_efficiency_units = 'kilometres_per_litre'", "fuel_efficiency IS NULL")
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
