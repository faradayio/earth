require 'spec_helper'
require 'earth/automobile/automobile_activity_year'

describe AutomobileActivityYear do
  before :all do
    Earth.init :automobile, :load_data_miner => true
    require 'earth/acronyms'
  end
  
  describe 'import', :data_miner => true do
    it 'should import data' do
      AAY.run_data_miner!
    end
  end
  
  describe 'verify', :sanity => true do
    it { AAY.count.should == 15 }
    it { AAY.where("hfc_emission_factor > 0").count.should == AAY.count }
    
    # spot check
    it { AAY.first.hfc_emission_factor.should be_within(1e-5).of(0.01657) }
    it { AAY.first.hfc_emission_factor_units.should == 'kilograms_co2e_per_kilometre' }
  end
  
  describe '.find_by_closest_year' do
    it { AAY.find_by_closest_year(1994).should == AAY.find(1995) }
    it { AAY.find_by_closest_year(2005).should == AAY.find(2005) }
    it { AAY.find_by_closest_year(2010).should == AAY.find(2009) }
  end
end
