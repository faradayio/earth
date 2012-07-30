require 'spec_helper'
require 'earth/locality/electricity_mix'

describe ElectricityMix do
  describe 'verify imported data', :sanity => true do
    let(:total) { ElectricityMix.count }
    let(:uk) { ElectricityMix.find_by_country_iso_3166_code 'GB' }
    let(:akgd) { ElectricityMix.find_by_egrid_subregion_abbreviation 'akgd' }
    let(:us) { ElectricityMix.find_by_country_iso_3166_code 'US' }
    let(:ca) { ElectricityMix.find_by_state_postal_abbreviation 'CA' }
    
    it { total.should == 213 }
    it { ElectricityMix.where('co2_emission_factor >= 0').count.should == total }
    it { ElectricityMix.where(:co2_emission_factor_units => 'kilograms_per_kilowatt_hour').count.should == total }
    it { ElectricityMix.where('ch4_emission_factor >= 0').count.should == total }
    it { ElectricityMix.where(:ch4_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour').count.should == total }
    it { ElectricityMix.where('n2o_emission_factor >= 0').count.should == total }
    it { ElectricityMix.where(:n2o_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour').count.should == total }
    it { ElectricityMix.where('loss_factor >= 0').count.should == total }
    it { ElectricityMix.maximum(:loss_factor).should < 0.3 }
    
    # spot checks
    it { uk.co2_emission_factor.should be_within(5e-6).of(0.5085) }
    it { uk.ch4_emission_factor.should be_within(5e-9).of(0.00016875) }
    it { uk.n2o_emission_factor.should be_within(5e-9).of(0.00152576) }
    it { uk.loss_factor.should be_within(5e-4).of(0.073) }
    
    it { akgd.co2_emission_factor.should be_within(5e-6).of(0.58099) }
    it { akgd.co2_biogenic_emission_factor.should == nil }
    it { akgd.ch4_emission_factor.should be_within(5e-6).of(0.00031) }
    it { akgd.n2o_emission_factor.should be_within(5e-6).of(0.00104) }
    it { akgd.loss_factor.should be_within(5e-6).of(0.0584) }
    
    it { us.co2_emission_factor.should be_within(5e-6).of(0.55165) }
    it { us.ch4_emission_factor.should be_within(5e-9).of(0.00027255) }
    it { us.n2o_emission_factor.should be_within(5e-8).of(0.0024437) }
    it { us.loss_factor.should be_within(5e-6).of(0.06503) }
    
    it { ca.co2_emission_factor.should be_within(5e-6).of(0.30163) }
    it { ca.ch4_emission_factor.should be_within(5e-6).of(0.00033) }
    it { ca.n2o_emission_factor.should be_within(5e-6).of(0.00085) }
    it { ca.loss_factor.should be_within(5e-6).of(0.08208) }
  end
  
  describe '.fallback' do
    it { ElectricityMix.fallback.name.should == 'fallback' }
    it { ElectricityMix.fallback.co2_emission_factor.should be_within(5e-6).of(0.62354) }
    it { ElectricityMix.fallback.ch4_emission_factor.should be_within(5e-6).of(0.00021) }
    it { ElectricityMix.fallback.n2o_emission_factor.should be_within(5e-6).of(0.00234) }
    it { ElectricityMix.fallback.loss_factor.should be_within(5e-6).of(0.096) }
  end
  
  describe '#energy_content' do
    it { ElectricityMix.first.energy_content.should be_within(5e-6).of(3.6) }
  end
  
  describe '#energy_content_units' do
    it { ElectricityMix.first.energy_content_units.should == 'megajoules_per_kilowatt_hour' }
  end
end
