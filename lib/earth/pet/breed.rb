class Breed < ActiveRecord::Base
  set_primary_key :name
  
  has_many :pets, :foreign_key => 'breed_id'
  has_many :breed_genders, :foreign_key => 'breed_name'
  belongs_to :species, :foreign_key => 'species_name'
  
  data_miner do
    tap "Brighter Planet's breed data", Earth.taps_server

    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
