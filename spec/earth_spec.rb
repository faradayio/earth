require 'spec_helper'

describe Earth do
  describe '.init' do
    before :all do
      Earth.init :all, :apply_schemas => true
    end

    it 'should require all Earth models' do
      lambda do
        Earth.resources.each { |k| k.constantize }
      end.should_not raise_error(NameError)
    end

    it 'should include data_miner definitions' do
      lambda do
        Earth.resources.each { |k| k.constantize.should_receive(:data_miner) }
      end
      require 'earth/data_miner'
    end
  end

  describe '.resources' do
    it 'should get a list of all resource names' do
      Earth.resources.length.should == 93
      Earth.resources.should include('Aircraft')
      Earth.resources.should include('Industry')
    end
    it 'should filter resource_map by domain' do
      Earth.resources('air').length.should == 10
      Earth.resources('automobile').length.should == 16
      Earth.resources('bus').length.should == 4
      Earth.resources('computation').length.should == 3
      Earth.resources('diet').length.should == 2
      Earth.resources('fuel').length.should == 5
      Earth.resources('hospitality').length.should == 3
      Earth.resources('industry').length.should == 13
      Earth.resources('locality').length.should == 10
      Earth.resources('pet').length.should == 4
      Earth.resources('rail').length.should == 12
      Earth.resources('residence').length.should == 9
      Earth.resources('shipping').length.should == 3
      Earth.resources('fuel').should include('FuelType')
    end
  end

  describe '.domains' do
    it 'should return a list of all domains' do
      Earth.domains.should == %w{air automobile bus computation diet fuel hospitality industry locality pet rail residence shipping}
    end
  end
end
