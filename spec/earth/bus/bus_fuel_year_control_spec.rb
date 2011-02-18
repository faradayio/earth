require 'spec_helper'

describe 'BusFuelYearControl' do
  before :all do
    Earth.init :bus, :fuel, :apply_schemas => true
    BusFuelYearControl.run_data_miner!
  end

  it 'imports successfully' do
    BusFuelYearControl.all.count.should > 0
  end
  it 'is related to BusFuelControl' do
    BusFuelControl.run_data_miner!
    BusFuelYearControl.first.control.should_not be_nil
  end
end

