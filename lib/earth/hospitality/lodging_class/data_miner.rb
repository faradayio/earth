require 'earth/locality/data_miner'
LodgingClass.class_eval do
  data_miner do
    process "Ensure CountryLodgingClass is populated" do
      CountryLodgingClass.run_data_miner!
    end
    
    process "Derive lodging classes from CountryLodgingClass" do
      connection.select_values("SELECT DISTINCT lodging_class_name FROM #{CountryLodgingClass.quoted_table_name}").each do |lodging_class_name|
        find_or_create_by_name lodging_class_name
      end
    end
  end
end
