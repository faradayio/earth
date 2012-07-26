require 'earth/fuel/data_miner'
AutomobileMakeModel.class_eval do
  data_miner do
    process "Ensure AutomobileMakeModelYear is populated" do
      AutomobileMakeModelYear.run_data_miner!
    end
    
    process "Derive model names from AutomobileMakeModelYear" do
      ::Earth::Utils.insert_ignore(
        :src => AutomobileMakeModelYear,
        :dest => AutomobileMakeModel,
        :cols => {
          [:make_name, :model_name] => :name,
          :make_name => :make_name,
          :model_name => :model_name
        }
      )
    end
    
    process "Derive fuel codes and type name from AutomobileMakeModelYear" do
      safe_find_each do |amm|
        codes = amm.model_years.map(&:fuel_code).uniq
        if codes.count == 1
          amm.update_attributes! :fuel_code => codes.first
        elsif codes.all?{ |code| ['R', 'P', 'G'].include? code }
          amm.update_attributes! :fuel_code => 'G'
        end
        
        alt_codes = amm.model_years.map(&:alt_fuel_code).uniq
        type_names = amm.model_years.map(&:type_name).uniq
        amm.update_attributes!(
          :alt_fuel_code => (alt_codes.first if alt_codes.count == 1),
          :type_name => (type_names.first if type_names.one?)
        )
      end
    end
    
    process "Derive fuel efficiencies from AutomobileMakeModelYear" do
      models = arel_table
      model_years = AutomobileMakeModelYear.arel_table
      join_relation = model_years[:make_name].eq(models[:make_name]).and(model_years[:model_name].eq(models[:model_name]))
      
      %w{ fuel_efficiency_city fuel_efficiency_highway }.each do |fe|
        fe_sql = AutomobileMakeModelYear.where(join_relation).weighted_average_relation("#{fe}").to_sql
        update_all %{
          #{fe} = (#{fe_sql}),
          #{fe}_units = 'kilometres_per_litre'
        }
      end
      
      %w{ alt_fuel_efficiency_city alt_fuel_efficiency_highway }.each do |fe|
        fe_sql = AutomobileMakeModelYear.where(join_relation).weighted_average_relation("#{fe}").to_sql
        where("alt_fuel_code IS NOT NULL").update_all %{
          #{fe} = (#{fe_sql}),
          #{fe}_units = 'kilometres_per_litre'
        }
      end
    end
  end
end
