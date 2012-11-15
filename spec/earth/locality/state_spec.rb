require 'spec_helper'
require 'earth/locality/state'

describe State do
  describe '#country' do
    it 'should return the United States' do
      us = Country.find_or_create_by_iso_3166_code 'US'
      State.new.country.should == us
    end
  end
  
  describe 'Sanity check', :sanity => true do
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
    
    it 'should have a RECS 2009 response grouping' do
      State.find('VT').recs_grouping_id.should == 1
      State.find('CA').recs_grouping_id.should == 26
      State.find('MT').recs_grouping_id.should == 23
      State.find('NM').recs_grouping_id.should == 25
    end
  end
end
