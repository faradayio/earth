AutomobileMake.class_eval do
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    process "Ensure AutomobileMakeModelYearVariant and AutomobileMakeFleetYear are populated" do
      AutomobileMakeModelYearVariant.run_data_miner!
      AutomobileMakeFleetYear.run_data_miner!
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
        :src => AutomobileMakeFleetYear,
        :dest => AutomobileMake,
        :cols => {
          :make_name => :name,
        }
      )
    end
    
    # FIXME TODO make this a method on AutomobileMake?
    process "Calculate fuel efficiency from automobile make fleet years for makes with CAFE data" do
      make_fleet_years = AutomobileMakeFleetYear.arel_table
      makes = AutomobileMake.arel_table
      conditional_relation = makes[:name].eq(make_fleet_years[:make_name])
      relation = AutomobileMakeFleetYear.weighted_average_relation(:fuel_efficiency, :weighted_by => :volume).where(conditional_relation)
      update_all "fuel_efficiency = (#{relation.to_sql})"
    end
    
    process "Calculate fuel effeciency from automobile make model year variants for makes without CAFE data" do
      update_all(
        %{fuel_efficiency = (SELECT AVG(automobile_make_model_year_variants.fuel_efficiency) FROM automobile_make_model_year_variants WHERE automobile_makes.name = automobile_make_model_year_variants.make_name)},
        'fuel_efficiency IS NULL'
      )
    end
    
    process "Set units" do
      update_all "fuel_efficiency_units = 'kilometres_per_litre'"
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
