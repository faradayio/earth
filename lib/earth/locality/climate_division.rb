class ClimateDivision < ActiveRecord::Base
  set_primary_key :name
  
  has_many :zip_codes, :foreign_key => 'climate_division_name'
  belongs_to :state, :foreign_key => 'state_postal_abbreviation'
  
  RADIUS = 750

  data_miner do
    tap "Brighter Planet's sanitized climate divisions", TAPS_SERVER

    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end

end
