require 'spec_helper'
require 'earth/automobile'
require 'earth/automobile/data_miner'

describe AutomobileFuel do
  describe 'import', :data_miner => true do
    it 'should import data without problems' do
      AutomobileFuel.run_data_miner!
      AutomobileFuel.all.count.should > 0
    end
    
    it 'correctly assigns hfc_emission_factor' do
      AutomobileFuel.first.hfc_emission_factor.should == 0.0
    end
  end
end
