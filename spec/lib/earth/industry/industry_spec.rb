require 'spec_helper'
Earth.init :industry, :apply_schemas => true

describe Industry do
  describe 'data_miner import' do
    before :all do
      require 'data_miner'
      require 'earth/industry/industry/data_miner'
    end
    it 'should import data' do
      Industry.destroy_all
      DataMiner.run :resource_names => 'Industry'
      Industry.count.should > 1
    end
  end
end

