class ResidenceClass < ActiveRecord::Base
  set_primary_key :name
  
  has_many :residential_energy_consumption_survey_responses

  CLASSIFICATIONS = ['mobile home', 'house', 'apartment']

  def classification
    CLASSIFICATIONS.detect { |c| name.downcase.include? c }
  end

  create_table do
    string :name
  end
end
