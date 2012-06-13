require 'spec_helper'
require 'earth/locality/egrid_subregion'

describe EgridSubregion do
  describe 'import', :data_miner => true do
    before do
      Earth.init :locality, :load_data_miner => true
    end
    
    it 'should import data' do
      EgridSubregion.run_data_miner!
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it { EgridSubregion.count.should == 26 }
    it { EgridSubregion.where("net_generation > 0").count.should == EgridSubregion.count }
    it { EgridSubregion.where("co2_emission_factor > 0").count.should == EgridSubregion.count }
    it { EgridSubregion.where("co2_biogenic_emission_factor >= 0").count.should == EgridSubregion.count }
    it { EgridSubregion.where("ch4_emission_factor > 0").count.should == EgridSubregion.count }
    it { EgridSubregion.where("n2o_emission_factor > 0").count.should == EgridSubregion.count }
    it { EgridSubregion.where("electricity_emission_factor > 0").count.should == EgridSubregion.count }
    
    # spot check
    it { EgridSubregion.first.net_generation.should be_within(5).of(5_337_982) }
    it { EgridSubregion.first.co2_emission_factor.should be_within(5e-6).of(0.58099) }
    it { EgridSubregion.first.co2_biogenic_emission_factor.should be_within(5e-6).of(0.0) }
    it { EgridSubregion.first.ch4_emission_factor.should be_within(5e-6).of(0.00031) }
    it { EgridSubregion.first.n2o_emission_factor.should be_within(5e-6).of(0.00104) }
    it { EgridSubregion.first.electricity_emission_factor.should be_within(5e-6).of(0.58234) }
    
    it { EgridSubregion.first.net_generation_units.should == 'megawatt_hours' }
    it { EgridSubregion.first.co2_emission_factor_units.should == 'kilograms_per_kilowatt_hour' }
    it { EgridSubregion.first.co2_biogenic_emission_factor_units.should == 'kilograms_per_kilowatt_hour' }
    it { EgridSubregion.first.ch4_emission_factor_units.should == 'kilograms_co2e_per_kilowatt_hour' }
    it { EgridSubregion.first.n2o_emission_factor_units.should == 'kilograms_co2e_per_kilowatt_hour' }
    it { EgridSubregion.first.electricity_emission_factor_units.should == 'kilograms_co2e_per_kilowatt_hour' }
  end
  
  describe '.fallback' do
    it { EgridSubregion.fallback.name.should == 'fallback' }
    it { EgridSubregion.fallback.egrid_region.name.should == 'fallback' }
    it { EgridSubregion.fallback.co2_emission_factor.should be_within(5e-6).of(0.55165) }
    it { EgridSubregion.fallback.co2_biogenic_emission_factor.should be_within(5e-6).of(0.0) }
    it { EgridSubregion.fallback.ch4_emission_factor.should be_within(5e-6).of(0.00027) }
    it { EgridSubregion.fallback.n2o_emission_factor.should be_within(5e-6).of(0.00244) }
    it { EgridSubregion.fallback.electricity_emission_factor.should be_within(5e-6).of(0.55437) }
  end
end
