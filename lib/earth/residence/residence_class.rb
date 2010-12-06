class ResidenceClass < ActiveRecord::Base
  set_primary_key :name
  
  has_many :residential_energy_consumption_survey_responses

  CLASSIFICATIONS = ['mobile home', 'house', 'apartment']

  def classification
    CLASSIFICATIONS.detect { |c| name.downcase.include? c }
  end

  data_miner do
    tap "Brighter Planet's sanitized residence class data", Earth.taps_server
  end
end
