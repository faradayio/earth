require 'spec_helper'
require 'earth/automobile/automobile_type_fuel_year_age'

describe AutomobileTypeFuelYearAge do
  describe 'import', :data_miner => true do
    before do
      Earth.init :automobile, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it 'imports and processes data successfully' do
      AutomobileTypeFuelYearAge.run_data_miner!
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it 'should have all the data' do
      AutomobileTypeFuelYearAge.count.should == 124
    end
  end
end
