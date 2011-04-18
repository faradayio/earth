class LodgingClassCountry < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :lodging_class, :foreign_key => 'lodging_class_name', :primary_key => 'name'
  
  data_miner do
    tap "Brighter Planet's lodging class data", Earth.taps_server
    
    process "Pull dependencies" do
      run_data_miner_on_belongs_to_associations!
    end
  end
end
