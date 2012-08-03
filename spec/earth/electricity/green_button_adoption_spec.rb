require 'spec_helper'
require 'earth/electricity/green_button_adoption'

describe GreenButtonAdoption do
  describe 'verify Green Button program adoption data', :sanity => true do
    it { GreenButtonAdoption.count.should == 19 }

    it 'should recognize that PG&E has implemented' do
      GreenButtonAdoption.find('PG&E').implemented?.should == true
    end

    it 'should recognize that TXU Energy has committed' do
      GreenButtonAdoption.find('TXU Energy').committed?.should == true
    end
  end
end
