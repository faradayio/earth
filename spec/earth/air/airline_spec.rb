require 'spec_helper'
require 'earth/air/airline'

describe Airline do
  before :all do
    Earth.init :air, :load_data_miner => true, :skip_parent_associations => :true
  end
  
  describe 'import', :data_miner => true do
    it 'should import data' do
      Airline.run_data_miner!
    end
  end
  
  describe "verify imported data", :sanity => true do
    it "should have all the data" do
      Airline.count.should == 1522
    end
  end
end
