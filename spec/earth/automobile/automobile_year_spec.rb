require 'spec_helper'
require 'earth/automobile/automobile_year'

describe AutomobileYear do
  describe ".weighting(year)" do
    (1985..2012).each do |year|
      it "returns a weighting between 0 and 1 for #{year}" do
        AutomobileYear.weighting(year).should > 0.0 and AutomobileYear.weighting(year).should < 1.0
      end
    end
  end
  
  describe 'Sanity check', :sanity => true do
    it { AutomobileYear.count.should == 28 }
  end
end
