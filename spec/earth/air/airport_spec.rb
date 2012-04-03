require 'spec_helper'
require 'earth/air/airport'

describe Airport do
  before :all do
    Airport.auto_upgrade!
  end
  
  describe "when importing data", :data_miner => true do
    before do
      require 'earth/air/airport/data_miner'
    end
    
    it "imports all airports" do
      Airport.run_data_miner!
      Airport.count.should == 5324
    end
  end
  
  describe "verify imported data", :sanity => true do
    it "should have name" do
      Airport.where(:name => nil).count.should == 0
    end
    
    it "should have city" do
      Airport.where(:city => nil).count.should == 0
    end
    
    it "should have country code" do
      Airport.where(:country_iso_3166_code => nil).count.should == 0
    end
    
    it "should have lat/lng" do
      Airport.where(:latitude => nil).count.should == 0
      Airport.where(:longitude => nil).count.should == 0
    end
    
    # FIXME TODO check for duplicate cities in same country
  end
end
