require 'spec_helper'
require 'earth/electricity/electric_utility'

describe ElectricUtility do
  describe 'Electric market data', :data_miner => true do
    before :all do
      Earth.init :electricity, :load_data_miner => true
      ElectricMarket.run_data_miner!
    end

    it 'Properly links 53704 to MG&E' do
      ZipCode.find('53704').electric_utilities.should_include ElectricUtility.find(11479)
    end
    
    after :all do
      ZipCode.delete_all
      ElectricMarket.delete_all
      ElectricUtility.delete_all
    end
  end
end
