require 'earth/automobile/automobile_type_fuel_year'

AutomobileTypeFuel.class_eval do
  data_miner do
    process "Ensure AutomobileTypeFuelYear is populated" do
      AutomobileTypeFuelYear.run_data_miner!
    end
    
    process "Derive from AutomobileTypeFuelYear" do
      ::Earth::Utils.insert_ignore(
        :src => AutomobileTypeFuelYear,
        :dest => AutomobileTypeFuel,
        :cols => {
          [:type_name, :fuel_family] => :name,
          :type_name => :type_name,
          :fuel_family => :fuel_family
        }
      )
    end
    
    process "Derive annual distance and emission factors from AutomobileTypeFuelYear" do
      type_fuels = arel_table
      type_fuel_years = AutomobileTypeFuelYear.arel_table
      join_relation = type_fuel_years[:type_name].eq(type_fuels[:type_name]).and(type_fuel_years[:fuel_family].eq(type_fuels[:fuel_family]))
      
      %w{ annual_distance ch4_emission_factor n2o_emission_factor }.each do |item|
        item_sql = AutomobileTypeFuelYear.where(join_relation).weighted_average_relation("#{item}", :weighted_by => :share_of_type).to_sql
        item_units = AutomobileTypeFuelYear.first.send("#{item}_units")
        
        update_all %{
          #{item} = (#{item_sql}),
          #{item}_units = '#{item_units}'
        }
      end
    end
    
    process "Ensure AutomobileActivityYearTypeFuel is populated" do
      AutomobileActivityYearTypeFuel.run_data_miner!
    end
    
    process "Derive number of vehicles and fuel consumption from AutomobileActivityYearTypeFuel" do
      safe_find_each do |atf|
        atf.update_attributes!(
          :vehicles => atf.latest_activity_year_type_fuel.distance / atf.annual_distance,
          :fuel_consumption => atf.latest_activity_year_type_fuel.fuel_consumption,
          :fuel_consumption_units => atf.latest_activity_year_type_fuel.fuel_consumption_units
        )
      end
    end
  end
end
