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
      
      Country.find('US').electricity_emission_factor.should be_within(0.00001).of(0.58946)
      Country.find('US').electricity_emission_factor_units.should == 'kilograms_co2e_per_kilowatt_hour'
      Country.find('US').electricity_loss_factor.should be_within(0.001).of(0.062)
      
      Country.find('GB').electricity_emission_factor.should be_within(0.00001).of(0.51020)
      Country.find('GB').electricity_emission_factor_units.should == 'kilograms_co2e_per_kilowatt_hour'
      Country.find('GB').electricity_loss_factor.should be_within(0.001).of(0.073)
    end
    
    it 'has fallback electricity emission factor and electricity loss factor' do
      Country.fallback.electricity_emission_factor.should be_within(0.00001).of(0.62609)
      Country.fallback.electricity_emission_factor_units.should == 'kilograms_co2e_per_kilowatt_hour'
      Country.fallback.electricity_loss_factor.should be_within(0.001).of(0.096)
    end
  end
  
  describe '.united_states' do
    it 'should return the United States' do
      Country.united_states.should == Country.find('US')
    end
  end
end
