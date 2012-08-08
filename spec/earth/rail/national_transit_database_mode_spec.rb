require 'spec_helper'
require "#{Earth::FACTORY_DIR}/national_transit_database_mode"

describe NationalTransitDatabaseMode do
  describe '.rail_modes' do
    it "should return all rail modes" do
      NationalTransitDatabaseMode.delete_all
      FactoryGirl.create :ntd_mode, :bus
      rail = FactoryGirl.create :ntd_mode, :rail
      NationalTransitDatabaseMode.rail_modes.should == [rail]
    end
  end
  
  describe 'Sanity check', :sanity => true do
    it { NationalTransitDatabaseMode.count.should == 14 }
    
    # spot check
    it { NationalTransitDatabaseMode.rail_modes.count.should == 8 }
    it { NationalTransitDatabaseMode.find('HR').rail_mode.should == true }
  end
end
