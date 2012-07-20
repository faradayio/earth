require 'spec_helper'
require 'earth/hospitality/lodging_class'

describe LodgingClass do
  describe 'when importing data', :data_miner => true do
    before do
      Earth.init :hospitality, :load_data_miner => true
    end
    
    it 'imports data' do
      LodgingClass.run_data_miner!
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it { LodgingClass.count.should == 3 }
  end
end
