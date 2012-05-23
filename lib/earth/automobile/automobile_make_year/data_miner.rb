require 'earth/fuel/data_miner'
AutomobileMakeYear.class_eval do
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    process "Ensure AutomobileMakeModelYearVariant and AutomobileMakeYearFleet are populated" do
      AutomobileMakeModelYearVariant.run_data_miner!
      AutomobileMakeYearFleet.run_data_miner!
    end
    
    process "Derive manufacturer names and years from AutomobileMakeModelYearVariant" do
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
    
    process "Calculate fuel efficiency and sales volume from AutomobileMakeYearFleet for makes with CAFE data" do
      make_years = arel_table
      year_fleets = AutomobileMakeYearFleet.arel_table
      join_relation = make_years[:make_name].eq(year_fleets[:make_name]).and(make_years[:year].eq(year_fleets[:year]))
      fuel_efficiency_relation = AutomobileMakeYearFleet.weighted_average_relation(:fuel_efficiency, :weighted_by => :volume)
      update_all("fuel_efficiency = (#{fuel_efficiency_relation.where(join_relation).to_sql})")
      where("fuel_efficiency IS NOT NULL").update_all "fuel_efficiency_units = 'kilometres_per_litre'"
    end
    
    process "Calculate fuel effeciency from AutomobileMakeModelYearVariant for makes without CAFE data" do
      make_years = arel_table
      variants = AutomobileMakeModelYearVariant.arel_table
      join_relation = make_years[:make_name].eq(variants[:make_name]).and(make_years[:year].eq(variants[:year]))
      fuel_efficiency_relation = variants.project(variants[:fuel_efficiency].average)
      where(:fuel_efficiency => nil).update_all(%{
        fuel_efficiency = (#{fuel_efficiency_relation.where(join_relation).to_sql}),
        fuel_efficiency_units = 'kilometres_per_litre'
      })
    end
    
    process "Derive weighting from AutomobileYear" do
      connection.select_values("SELECT DISTINCT year FROM #{quoted_table_name}").each do |year|
        where(:year => year).update_all "weighting = #{AutomobileYear.weighting(year)}"
      end
    end
  end
end
