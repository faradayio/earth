require 'spec_helper'
require 'earth/automobile'
require 'earth/automobile/data_miner'

describe AutomobileFuel do
  before :all do
    AutomobileFuel.run_data_miner!
  end

  it 'imports data without problems' do
    AutomobileFuel.all.count.should > 0
  end
  it 'correctly assigns hfc_emission_factor' do
    AutomobileTypeFuelAge.run_data_miner!
    AutomobileTypeFuelYear.run_data_miner!
    AutomobileTypeYear.run_data_miner!
    AutomobileFuel.first.hfc_emission_factor.should == 0.0
  end
end

