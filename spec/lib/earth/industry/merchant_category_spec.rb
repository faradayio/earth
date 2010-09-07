require 'spec_helper'
Earth.init :industry, :apply_schemas => true

describe MerchantCategory do
  describe 'data_miner import' do
    before :all do
      require 'data_miner'
    end
    it 'should import data' do
      MerchantCategory.destroy_all
      DataMiner.run :resource_names => 'MerchantCategory'
      MerchantCategory.count.should > 1
    end
  end
end
