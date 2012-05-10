require 'spec_helper'
require 'earth/electricity/green_button_adoption'

describe GreenButtonAdoption do
  describe 'Green Button program adoption data', :data_miner => true do
    before :all do
      Earth.init :electricity, :load_data_miner => true
      GreenButtonAdoption.run_data_miner!
    end

    it 'Recognizes that PG&E has implemented' do
      GreenButtonAdoption.find('PG&E').implemented?.should == true
    end
    
    after :all do
      GreenButtonAdoption.delete_all
    end    
  end
end
