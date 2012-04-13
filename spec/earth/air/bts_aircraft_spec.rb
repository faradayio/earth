require 'spec_helper'
require 'earth/air/bts_aircraft'

describe BtsAircraft do
  before :all do
    BtsAircraft.auto_upgrade!
  end
  
  describe 'import', :data_miner => true do
    before do
      require 'earth/air/bts_aircraft/data_miner'
    end
    
    it 'should import data' do
      BtsAircraft.run_data_miner!
      BtsAircraft.all.count.should == 378
    end
  end
end
