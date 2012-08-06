require 'earth/rail/country_rail_traction'
require 'earth/rail/country_rail_traction_class'

RailTraction.class_eval do
  data_miner do
    process "Ensure CountryRailTraction and CountryRailTractionClass are populated" do
      CountryRailTractionClass.run_data_miner!
      CountryRailTraction.run_data_miner!
    end
    
    process "Derive rail traction names from CountryRailTraction and CountryRailTractionClass" do
      names = []
      names += CountryRailTractionClass.select("DISTINCT rail_traction_name").map(&:rail_traction_name)
      names += CountryRailTraction.select("DISTINCT rail_traction_name").map(&:rail_traction_name)
      names.uniq.each do |name|
        RailTraction.find_or_create_by_name(name)
      end
    end
  end
end
