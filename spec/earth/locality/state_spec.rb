require 'spec_helper'
require 'earth/locality/state'

describe State do
  describe 'when importing data', :data_miner => true do
    before do
      Earth.init :locality, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it 'imports data' do
      State.run_data_miner!
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it 'should have all the data' do
      State.count.should == 51 # includes DC but not any territories
    end
    it 'should have a population' do
      State.find('VT').population.should == 625741
      State.find('CA').population.should == 37249542
      State.find('MT').population.should == 990213
      State.find('NM').population.should == 2056349
    end
  end
  
  describe '#country' do
    before do
      require 'earth/locality/country'
    end
    
    it 'should return the United States' do
      State.first.country.should == Country.united_states
    end
  end
end
