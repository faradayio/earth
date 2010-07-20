require 'spec_helper'

describe Earth do
  before :all do
    Earth.init :all, :apply_schemas => true
  end

  it 'should require all Earth models' do
    lambda do
      Earth.classes.each { |k| k }
    end.should_not raise_error(NameError)
  end

  it 'should include data_miner definitions' do
    lambda do
      Earth.classes.each { |k| k.should_receive(:data_miner) }
    end
    require 'earth/data_miner'
  end

  it 'should create a fallbacks table' do
    Fallback.should be_table_exists
  end
end

