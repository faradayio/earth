require 'spec_helper'

describe Earth do
  describe '.init' do
    before :all do
      Earth.init :all
    end

    it 'should require all Earth models' do
      lambda do
        Earth.resources.each { |k| k.constantize }
      end.should_not raise_error(NameError)
    end
  end

  describe '.resources' do
    it 'should get a list of all resource names' do
      Earth.init :all
      Earth.resources.length.should == 100
      Earth.resources.should include('Aircraft')
      Earth.resources.should include('Industry')
    end
  end
end
