require 'spec_helper'

describe Earth do
  it 'should require all Earth models' do
    require 'earth/all'
    lambda do
      Earth.classes.each { |k| k }
    end.should_not raise_error(NameError)
  end

  it 'should include data_miner definitions' do
    require 'earth/all'
    lambda do
      Earth.classes.each { |k| k.should_receive(:data_miner) }
    end
    require 'earth/data_miner'
  end
end

