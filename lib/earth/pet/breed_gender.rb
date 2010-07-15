class BreedGender < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :breed, :foreign_key => 'breed_name'
  belongs_to :gender, :foreign_key => 'gender_name'
  
  data_miner do
    tap "Brighter Planet's breed gender data", Earth.taps_server

    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
