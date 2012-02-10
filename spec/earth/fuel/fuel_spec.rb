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
      Fuel.run_data_miner!
      Fuel.all.count.should == 12
    end 
  end
end
