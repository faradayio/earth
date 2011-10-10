RailClass.class_eval do
  data_miner do
    process "Ensure CountryRailClass, CountryRailTractionClass, and RailCompanyTractionClass are populated" do
      CountryRailTractionClass.run_data_miner!
      CountryRailClass.run_data_miner!
      RailCompanyTractionClass.run_data_miner!
    end
    
    process "Derive rail class names from CountryRailClass, CountryRailTractionClass, and RailCompanyTractionClass" do
      names = []
      names += CountryRailTractionClass.select("DISTINCT rail_class_name").map(&:rail_class_name)
      names += CountryRailClass.select("DISTINCT rail_class_name").map(&:rail_class_name)
      names += RailCompanyTractionClass.select("DISTINCT rail_class_name").map(&:rail_class_name)
      names.uniq.each do |name|
        RailClass.find_or_create_by_name(name)
      end
    end
  end
end
