require 'spec_helper'

describe 'BusFuel' do
  before :all do
    Earth.init :bus, :fuel, :apply_schemas => true
  end

  describe 'import', :slow => true do
    it 'is related to fuels' do
      BusFuel.run_data_miner!
      BusFuel.last.fuel.should_not be_nil
    end
  end
end
