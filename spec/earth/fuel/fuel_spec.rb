require 'spec_helper'
require 'earth/fuel/fuel'
require 'earth/fuel/fuel/data_miner'

describe Fuel do
  before :all do
    Fuel.auto_upgrade!
  end
  before :each do
    Fuel.delete_all
  end
  
  describe 'import', :slow => true do
    it 'fetches all fuels' do
      Earth.init :fuel, :load_data_miner => true
      Fuel.run_data_miner!
      Fuel.count.should == 21
    end 
  end
end
