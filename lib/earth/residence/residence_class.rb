class ResidenceClass < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "residence_classes"
  (
     "name" CHARACTER VARYING(255) NOT NULL
  );
ALTER TABLE "residence_classes" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  
  has_many :residential_energy_consumption_survey_responses

  CLASSIFICATIONS = ['mobile home', 'house', 'apartment']

  def classification
    CLASSIFICATIONS.detect { |c| name.downcase.include? c }
  end


  warn_unless_size 5
end
