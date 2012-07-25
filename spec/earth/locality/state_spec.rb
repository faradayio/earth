require 'spec_helper'
require 'earth/locality/state'

describe State do
  describe 'when importing data', :data_miner => true do
    before do
      Earth.init :locality, :load_data_miner => true
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
      State.find('VT').electricity_emission_factor.should be_within(5e-6).of(0.33313)
      State.find('VT').electricity_emission_factor_units.should == "kilograms_co2e_per_kilowatt_hour"
      State.find('CA').electricity_emission_factor.should be_within(5e-6).of(0.30281)
      State.find('CA').electricity_emission_factor_units.should == "kilograms_co2e_per_kilowatt_hour"
      State.find('MT').electricity_emission_factor.should be_within(5e-6).of(0.39160)
      State.find('MT').electricity_emission_factor_units.should == "kilograms_co2e_per_kilowatt_hour"
      State.find('NM').electricity_emission_factor.should be_within(5e-6).of(0.54601)
      State.find('NM').electricity_emission_factor_units.should == "kilograms_co2e_per_kilowatt_hour"
    end
    
    it 'should have an average electricity loss factor' do
      State.find('VT').electricity_loss_factor.should be_within(5e-6).of(0.05822)
      State.find('CA').electricity_loss_factor.should be_within(5e-6).of(0.08208)
      State.find('MT').electricity_loss_factor.should be_within(5e-6).of(0.08094)
      State.find('NM').electricity_loss_factor.should be_within(5e-6).of(0.08007)
    end
  end
  
  describe '#country' do
    before do
      require 'earth/locality/country'
    end
    
    it 'should return the United States' do
      State.first.country.should == Country.united_states
    end
  end
end
