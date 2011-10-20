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
          [:make_name, :year] => :name,
          :make_name => :make_name,
          :year => :year
        }
      )
    end
    
    process "Calculate fuel efficiency and sales volume from make fleet years for makes with CAFE data" do
      make_years = arel_table
      fleet_years = AutomobileMakeFleetYear.arel_table
      conditional_relation = make_years[:make_name].eq(fleet_years[:make_name]).and(make_years[:year].eq(fleet_years[:year]))
      fuel_efficiency_relation = AutomobileMakeFleetYear.weighted_average_relation(:fuel_efficiency, :weighted_by => :volume).where(conditional_relation)
      volume_relation = fleet_years.project(fleet_years[:volume].sum).where(conditional_relation)
      update_all "fuel_efficiency = (#{fuel_efficiency_relation.to_sql}), fuel_efficiency_units = 'kilometres_per_litre', volume = (#{volume_relation.to_sql})"
    end
    
    process "Calculate fuel effeciency from automobile make model year variants for makes without CAFE data" do
      make_years = arel_table
      variants = AutomobileMakeModelYearVariant.arel_table
      conditional_relation = make_years[:make_name].eq(variants[:make_name]).and(make_years[:year].eq(variants[:year]))
      relation = variants.project(variants[:fuel_efficiency].average).where(conditional_relation)
      update_all("fuel_efficiency = (#{relation.to_sql}), fuel_efficiency_units = 'kilometres_per_litre'", "fuel_efficiency IS NULL")
    end
  end
end
