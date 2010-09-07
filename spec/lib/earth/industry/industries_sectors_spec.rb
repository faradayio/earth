require 'spec_helper'
Earth.init :industry, :apply_schemas => true

describe IndustriesSectors do
  describe 'data_miner import' do
    before :all do
      require 'data_miner'
      require 'earth/industry/industries_sectors/data_miner'
    end
    it 'should import data' do
      IndustriesSectors.destroy_all
      DataMiner.run :resource_names => 'IndustriesSectors'
      IndustriesSectors.count.should > 1
    end
  end
end

