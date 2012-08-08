require 'spec_helper'
require "#{Earth::FACTORY_DIR}/bus_fuel"
require "#{Earth::FACTORY_DIR}/bus_fuel_year_control"

describe BusFuel do
  describe '#latest_fuel_year_controls' do
    it 'returns the latest fuel year controls' do
      FactoryGirl.create :bfyc, :gas_2009_1
      a = FactoryGirl.create :bfyc, :gas_2010_1
      b = FactoryGirl.create :bfyc, :gas_2010_2
      gas = FactoryGirl.create :bus_fuel, :gas
      gas.latest_fuel_year_controls.should == [a,b]
    end
  end
  
  describe 'Sanity check', :sanity => true do
    it { BusFuel.count.should == 7 }
    
    # FIXME TODO more sanity checks
  end
end
