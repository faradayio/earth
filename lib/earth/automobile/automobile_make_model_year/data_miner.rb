AutomobileMakeModelYear.class_eval do
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    process "Ensure AutomobileMakeModelYearVariant is populated" do
      AutomobileMakeModelYearVariant.run_data_miner!
    end
    
    process "Derive names AutomobileMakeModelYearVariant" do
      ::Earth::Utils.insert_ignore(
        :src => AutomobileMakeModelYearVariant,
        :dest => AutomobileMakeModelYear,
        :cols => {
          [:make_name, :model_name, :year] => :name,
          :make_name => :make_name,
          :model_name => :model_name,
          :year => :year,
        }
      )
    end
    
    process "Identify hybrid vehicles" do
      where("model_name LIKE '%HYBRID%'").update_all :hybridity => true
      where("make_name = 'Infiniti' AND model_name REGEXP '[A-Z][0-9]{2}H'").update_all :hybridity => true
      where("make_name = 'Lexus' AND model_name REGEXP '[A-Z]{2}[0-9]{3}H'").update_all :hybridity => true
      where(:make_name => 'Chevrolet', :model_name => 'VOLT').update_all :hybridity => true
      where(:make_name => 'Honda', :model_name => 'INSIGHT').update_all :hybridity => true
      where(:make_name => 'Honda', :model_name => 'CR-Z').update_all :hybridity => true
      where("make_name = 'Toyota' AND model_name LIKE 'PRIUS%'").update_all :hybridity => true
      where(:hybridity => nil).update_all :hybridity => false
    end
    
    process "Derive fuel codes from AutomobileMakeModelYearVariant" do
      model_years = arel_table
      variants = AutomobileMakeModelYearVariant.arel_table
      join_relation = variants[:make_name].eq(model_years[:make_name]).and(variants[:model_name].eq(model_years[:model_name])).and(variants[:year].eq(model_years[:year]))
      
      update_all "fuel_code = (#{variants.project('GROUP_CONCAT(DISTINCT fuel_code)').where(join_relation).to_sql})"
      update_all "alt_fuel_code = (#{variants.project('GROUP_CONCAT(DISTINCT alt_fuel_code)').where(join_relation).to_sql})"
      where(:fuel_code => ['R,P', 'P,R']).update_all "fuel_code = 'G'"
    end
    
    # FIXME TODO: weight by volume somehow
    process "Calculate city and highway fuel efficiency from AutomobileMakeModelYearVariants" do
      model_years = arel_table
      variants = AutomobileMakeModelYearVariant.arel_table
      
      join_relation = model_years[:make_name].eq(variants[:make_name]).and(model_years[:model_name].eq(variants[:model_name])).and(model_years[:year].eq(variants[:year]))
      %w{ fuel_efficiency_city fuel_efficiency_highway }.each do |fe|
        update_all(%{
          #{fe} = (#{variants.project(variants["#{fe}"].average).where(join_relation).to_sql}),
          #{fe}_units = 'kilometres_per_litre'
        })
        where("alt_fuel_code IS NOT NULL").update_all(%{
          alt_#{fe} = (#{variants.project(variants["alt_#{fe}"].average).where(join_relation).to_sql}),
          alt_#{fe}_units = 'kilometres_per_litre'
        })
      end
    end
    
    process "Derive type name from AutomobileMakeModelYearVariant" do
      find_each do |ammy|
        type_names = AutomobileMakeModelYearVariant.where(:make_name => ammy.make_name, :model_name => ammy.model_name, :year => ammy.year).map(&:type_name).uniq
        ammy.type_name = (type_names.one? ? type_names.first : nil)
        ammy.save!
      end
    end
    
    # For calculating AutomobileMakeModel fuel efficiencies
    process "Derive weighting from AutomobileYear" do
      connection.select_values("SELECT DISTINCT year FROM #{quoted_table_name}").each do |year|
        where(:year => year).update_all "weighting = #{AutomobileYear.weighting(year)}"
      end
    end
  end
end
