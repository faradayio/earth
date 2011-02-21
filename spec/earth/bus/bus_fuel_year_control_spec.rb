require 'spec_helper'

describe 'BusFuelYearControl' do
  before :all do
    Earth.init :bus, :fuel, :apply_schemas => true
  end
  
  it 'imports successfully' do
    BusFuelYearControl.run_data_miner!
    BusFuelYearControl.all.count.should > 0
  end
  
  it 'is related to BusFuelControl' do
    BusFuelYearControl.first.control.should_not be_nil
  end
end
