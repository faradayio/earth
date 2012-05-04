require 'spec_helper'
require 'earth/locality/state'

describe State do
  describe 'when importing data', :data_miner => true do
    before do
      Earth.init :locality, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it 'imports data' do
      State.run_data_miner!
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it 'should have all the data' do
      State.count.should == 51 # includes DC but not any territories
    end
    it 'should have a population' do
      State.find('VT').population.should == 625741
      State.find('CA').population.should == 37249542
      State.find('MT').population.should == 990213
      State.find('NM').population.should == 2056349
    end
    
    it 'should have an average electricity emission factor' do
      State.find('VT').electricity_emission_factor.should be_within(0.00001).of(0.37848)
      State.find('VT').electricity_emission_factor_units.should == "kilograms_co2e_per_kilowatt_hour"
      State.find('CA').electricity_emission_factor.should be_within(0.00001).of(0.31315)
      State.find('CA').electricity_emission_factor_units.should == "kilograms_co2e_per_kilowatt_hour"
      State.find('MT').electricity_emission_factor.should be_within(0.00001).of(0.41092)
      State.find('MT').electricity_emission_factor_units.should == "kilograms_co2e_per_kilowatt_hour"
      State.find('NM').electricity_emission_factor.should be_within(0.00001).of(0.57194)
      State.find('NM').electricity_emission_factor_units.should == "kilograms_co2e_per_kilowatt_hour"
    end
    
    it 'should have an average electricity loss factor' do
      State.find('VT').electricity_loss_factor.should be_within(0.00001).of(0.0647079)
      State.find('CA').electricity_loss_factor.should be_within(0.00001).of(0.0483723)
      State.find('MT').electricity_loss_factor.should be_within(0.00001).of(0.0491516)
      State.find('NM').electricity_loss_factor.should be_within(0.00001).of(0.0499872)
    end
  end
  
  describe '#country' do
    before do
      require 'earth/locality/country'
    end
    
    it 'should the United States' do
      State.first.country.should == Country.united_states
      State.last.country.should == Country.united_states
    end
  end
end
