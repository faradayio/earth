require 'spec_helper'
require 'earth/locality'
require 'earth/locality/data_miner'

describe Country do
  describe 'import', :slow => true do
    it 'should import data' do
      Earth.init 'locality', :load_data_miner => true, :apply_schemas => true
      Country.run_data_miner!
      Country.all.count.should == 249
    end
    
    it 'should correctly determine climate zone number' do
      Country.find('LT').climate_zone_number.should == 1
      Country.find('HU').climate_zone_number.should == 2
      Country.find('HR').climate_zone_number.should == 3
      Country.find('CY').climate_zone_number.should == 4
      Country.find('UZ').climate_zone_number.should == 5
      Country.where(:heating_degree_days => nil).first.climate_zone_number.should == nil
    end
  end
end
