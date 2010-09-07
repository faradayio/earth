require 'spec_helper'
Earth.init :industry, :apply_schemas => true

describe Merchant do
  describe 'data_miner import' do
    before :all do
      require 'data_miner'
      require 'earth/industry/merchant/data_miner'
    end
    it 'should import data' do
      Merchant.destroy_all
      DataMiner.run :resource_names => 'Merchant'
      Merchant.count.should > 1
    end
  end
end

