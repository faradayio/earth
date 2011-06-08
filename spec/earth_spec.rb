require 'spec_helper'

describe Earth do
  describe '.init' do
    before :all do
      Earth.init :all, :apply_schemas => true
    end

    it 'should require all Earth models' do
      lambda do
        Earth.search.each { |k| k.constantize }
      end.should_not raise_error(NameError)
    end

    it 'should include data_miner definitions' do
      lambda do
        Earth.search.each { |k| k.constantize.should_receive(:data_miner) }
      end
      require 'earth/data_miner'
    end
  end

  describe '.resource_map' do
    it 'should get a list of resource_map' do
      resource_map = Earth.resource_map
      resource_map.keys.count.should == 76
      resource_map['FuelType'][:domain].should == 'fuel'
    end
    it 'should exclude data_miner files' do
      Earth.resource_map.keys.should_not include('DataMiner')
    end
  end

  describe '.search' do
    it 'should get a list of all resource names' do
      Earth.search.count.should == 76
      Earth.search.should include('Aircraft')
      Earth.search.should include('Industry')
    end
    it 'should filter resource_map by domain' do
      Earth.search(['fuel']).count.should == 5
      Earth.search(['fuel']).should include('FuelType')
    end
  end

  describe '.domains' do
    it 'should return a list of all domains' do
      Earth.domains.should == %w{air automobile bus computation diet fuel hospitality industry locality pet rail residence shipping}
    end
  end
end
