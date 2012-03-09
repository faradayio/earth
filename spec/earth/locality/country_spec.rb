require 'spec_helper'
require 'earth/locality/country'

describe Country do
  before :all do
    Country.auto_upgrade!
  end
  
  describe 'import', :slow => true do
    before do
      require 'earth/locality/country/data_miner'
    end
    
    it 'should import data' do
      Country.run_data_miner!
      Country.all.count.should == 249
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it 'has valid electricity emission factor and electricity loss factor for most countries' do
      Country.where('electricity_emission_factor IS NOT NULL').count.should == 136
      Country.where(:electricity_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour').count.should == 136
      Country.where('electricity_loss_factor IS NOT NULL').count.should == 136
      
      Country.minimum(:electricity_emission_factor).should >= 0.0
      Country.minimum(:electricity_loss_factor).should >= 0.0
      Country.maximum(:electricity_loss_factor).should < 0.3
      
      us = Country.united_states
      us.electricity_emission_factor.should be_within(0.00001).of(0.58946)
      us.electricity_emission_factor_units.should == 'kilograms_co2e_per_kilowatt_hour'
      us.electricity_loss_factor.should be_within(0.001).of(0.062)
      
      uk = Country.find 'GB'
      uk.electricity_emission_factor.should be_within(0.00001).of(0.51020)
      uk.electricity_emission_factor_units.should == 'kilograms_co2e_per_kilowatt_hour'
      uk.electricity_loss_factor.should be_within(0.001).of(0.073)
    end
    
    it 'has fallback electricity emission factor and electricity loss factor' do
      fallback = Country.fallback
      fallback.electricity_emission_factor.should be_within(0.00001).of(0.62609)
      fallback.electricity_emission_factor_units.should == 'kilograms_co2e_per_kilowatt_hour'
      fallback.electricity_loss_factor.should be_within(0.001).of(0.096)
    end
    
    it 'has lodging data for the US' do
      us = Country.united_states
      us.lodging_occupancy_rate.should be_within(0.001).of(0.601)
      us.lodging_natural_gas_intensity.should be_within(0.00001).of(1.93316)
      us.lodging_natural_gas_intensity_units.should == 'cubic_metres_per_occupied_room_night'
    end
  end
  
  describe '.united_states' do
    it 'should return the United States' do
      Country.united_states.should == Country.find('US')
    end
  end
end
