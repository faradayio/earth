require 'spec_helper'

describe Earth do
  describe '.init' do
    before :all do
      Earth.init :all, :apply_schemas => true
    end

    it 'should require all Earth models' do
      lambda do
        Earth.resource_names.each { |k| k.constantize }
      end.should_not raise_error(NameError)
    end

    it 'should include data_miner definitions' do
      lambda do
        Earth.resource_names.each { |k| k.constantize.should_receive(:data_miner) }
      end
      require 'earth/data_miner'
    end

    it 'should create a fallbacks table' do
      Fallback.should be_table_exists
    end
  end

  describe '.resources' do
    it 'should get a list of resources' do
      resources = Earth.resources
      resources.keys.count.should == 63
      resources['FuelType'][:domain].should == 'fuel'
    end
    it 'should exclude data_miner files' do
      Earth.resources.keys.should_not include('DataMiner')
    end
  end

  describe '.resource_names' do
    it 'should get a list of all resource names' do
      Earth.resource_names.count.should == 63
      Earth.resource_names.should include('Aircraft')
      Earth.resource_names.should include('Industry')
    end
    it 'should filter resources by domain' do
      Earth.resource_names(['fuel']).count.should == 2
      Earth.resource_names(['fuel']).should include('FuelType')
    end
  end

  describe '.domains' do
    it 'should return a list of all domains' do
      Earth.domains.should == %w{air automobile bus computation diet fuel hospitality industry locality pet rail residence shipping}
    end
  end
end

