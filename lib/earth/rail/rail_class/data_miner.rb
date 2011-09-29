RailClass.class_eval do
  data_miner do
    process "Ensure CountryRailMode is populated" do
      CountryRailMode.run_data_miner!
    end
    
    process "Synthesize a list of rail modes from CountryRailMode" do
      
    end
  end
end
