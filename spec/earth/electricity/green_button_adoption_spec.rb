require 'spec_helper'
require 'earth/electricity/green_button_adoption'

describe GreenButtonAdoption do
  describe 'import Green Button program adoption data', :data_miner => true do
    before :all do
      Earth.init :electricity, :load_data_miner => true
    end
    
    it 'imports data' do
      GreenButtonAdoption.run_data_miner!
    end
  end
  
  describe 'verify Green Button program adoption data', :sanity => true do
    it { GreenButtonAdoption.count.should == 19 }

    it 'should recognize that PG&E has implemented' do
      GreenButtonAdoption.find('PG&E').implemented?.should == true
    end
  end
end
