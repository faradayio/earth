require 'spec_helper'
require 'earth/automobile'

describe AutomobileFuel do
  describe 'import', :data_miner => true do
    before do
      Earth.init :automobile, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it 'should import data without problems' do
      AutomobileFuel.run_data_miner!
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it 'should have all the data' do
      AutomobileFuel.all.count.should == 9
    end
    it 'correctly assigns hfc_emission_factor' do
      AutomobileFuel.first.hfc_emission_factor.should == 0.124799
    end
  end
end
