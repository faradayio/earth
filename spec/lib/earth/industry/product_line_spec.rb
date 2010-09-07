require 'spec_helper'
Earth.init :industry, :apply_schemas => true

describe ProductLine do
  describe 'data_miner import' do
    before :all do
      require 'data_miner'
      require 'earth/industry/merchant/data_miner'
    end
    it 'should import data' do
      ProductLine.destroy_all
      DataMiner.run :resource_names => 'ProductLine'
      ProductLine.count.should > 1
    end
  end
end

