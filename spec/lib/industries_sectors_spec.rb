require 'spec_helper'
Earth.init :industry, :apply_schemas => true

describe IndustriesProductLines do
  describe 'data_miner import' do
    before :all do
      require 'data_miner'
      require 'earth/industry/industries_product_lines/data_miner'
    end
    it 'should import data' do
      IndustriesProductLines.destroy_all
      DataMiner.run :resource_names => 'IndustriesProductLines'
      IndustriesProductLines.count.should > 1
    end
  end
end

