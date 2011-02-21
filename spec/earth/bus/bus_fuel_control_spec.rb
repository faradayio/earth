require 'spec_helper'

describe 'BusFuelControl' do
  before :all do
    Earth.init :bus, :fuel, :apply_schemas => true
  end

  it 'imports successfully' do
    BusFuelControl.run_data_miner!
    BusFuelControl.all.count.should > 0
  end
end
