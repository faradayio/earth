AutomobileMakeYear.class_eval do
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    process "Ensure AutomobileMakeModelYearVariant and AutomobileMakeFleetYear are populated" do
      AutomobileMakeModelYearVariant.run_data_miner!
      AutomobileMakeFleetYear.run_data_miner!
    end
    
    process "Derive manufacturer names and years from automobile make model year variants" do
      ::Earth::Utils.insert_ignore(
        :src => AutomobileMakeModelYearVariant,
        :dest => AutomobileMakeYear,
        :cols => {
          :make_year_name => :name,
          :make_name => :make_name,
          :year => :year
        }
        # :where => 'src.make_name IS NOT NULL AND LENGTH(src.make_name) > 0 AND src.year IS NOT NULL AND LENGTH(src.year) > 0'
      )
    end
    
    # FIXME TODO make this a method on AutomobileMakeYear?
    process "Calculate fuel efficiency from make fleet years for makes with CAFE data" do
      make_fleet_years = AutomobileMakeFleetYear.arel_table
      make_years = AutomobileMakeYear.arel_table
      conditional_relation = make_years[:name].eq(make_fleet_years[:make_year_name])
      relation = AutomobileMakeFleetYear.weighted_average_relation(:fuel_efficiency, :weighted_by => :volume).where(conditional_relation)
      update_all "fuel_efficiency = (#{relation.to_sql})"
    end
    
    process "Calculate fuel effeciency from automobile make model year variants for makes without CAFE data" do
      update_all(
        %{fuel_efficiency = (SELECT AVG(automobile_make_model_year_variants.fuel_efficiency) FROM automobile_make_model_year_variants WHERE automobile_make_years.name = automobile_make_model_year_variants.make_year_name)},
        %{fuel_efficiency IS NULL}
      )
    end
    
    process "Calculate sales volume from automobile make fleet years for makes with CAFE data" do
      update_all %{volume = (SELECT SUM(automobile_make_fleet_years.volume) FROM automobile_make_fleet_years WHERE automobile_make_fleet_years.make_year_name = automobile_make_years.name)}
    end
    
    process 'Set units' do
      update_all "fuel_efficiency_units = 'kilometres_per_litre'"
    end
  end
end
