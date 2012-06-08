require 'spec_helper'
require 'earth/automobile/automobile_year'

describe AutomobileYear do
  before :all do
    Earth.init :automobile, :load_data_miner => true
  end
  
  describe 'import', :data_miner => true do
    it 'should import data' do
      AutomobileYear.run_data_miner!
      AutomobileYear.count.should == AutomobileYear.connection.select_value("SELECT COUNT(DISTINCT year) FROM #{AutomobileMakeModelYearVariant.quoted_table_name}")
    end
  end
  
  describe ".weighting(year)" do
    (1985..2012).each do |year|
      it "returns a weighting between 0 and 1 for #{year}" do
        AutomobileYear.weighting(year).should > 0.0 and AutomobileYear.weighting(year).should < 1.0
      end
    end
  end
end
