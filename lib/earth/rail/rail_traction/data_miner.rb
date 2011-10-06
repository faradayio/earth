RailTraction.class_eval do
  data_miner do
    process "Ensure CountryRailTraction, CountryRailTractionClass, RailCompanyTraction, and RailCompanyTractionClass are populated" do
      CountryRailTractionClass.run_data_miner!
      CountryRailTraction.run_data_miner!
      RailCompanyTractionClass.run_data_miner!
      RailCompanyTraction.run_data_miner!
    end
    
    process "Derive rail traction names from CountryRailTraction, CountryRailTractionClass, RailCompanyTraction, and RailCompanyTractionClass" do
      names = []
      names += CountryRailTractionClass.select("DISTINCT rail_traction_name").map(&:rail_traction_name)
      names += CountryRailTraction.select("DISTINCT rail_traction_name").map(&:rail_traction_name)
      names += RailCompanyTractionClass.select("DISTINCT rail_traction_name").map(&:rail_traction_name)
      names += RailCompanyTraction.select("DISTINCT rail_traction_name").map(&:rail_traction_name)
      names.uniq.each do |name|
        RailTraction.find_or_create_by_name(name)
      end
    end
  end
end
