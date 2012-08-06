require 'spec_helper'
require 'earth/residence/residential_energy_consumption_survey_response'

describe ResidentialEnergyConsumptionSurveyResponse do
  describe "Sanity check", :sanity => true do
    let(:recs) { ResidentialEnergyConsumptionSurveyResponse }
    let(:total) { recs.count }
    
    it { total.should == 4382 }
    
    # FIXME TODO more sanity checks
  end
end
