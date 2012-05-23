require 'earth/fuel/data_miner'
AutomobileMakeModel.class_eval do
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
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
  end
end
