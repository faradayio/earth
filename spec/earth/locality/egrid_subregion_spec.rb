require 'spec_helper'
require 'earth/locality/egrid_subregion'

describe EgridSubregion do
  describe 'Sanity check', :sanity => true do
    let(:total) { EgridSubregion.count }
    let(:akgd) { EgridSubregion.find 'akgd' }
    
    it { total.should == 26 }
    it { EgridSubregion.where("net_generation > 0").count.should == total }
    it { EgridSubregion.where("co2_emission_factor > 0").count.should == total }
    it { EgridSubregion.where(:co2_biogenic_emission_factor => nil).count.should == total }
    it { EgridSubregion.where("ch4_emission_factor > 0").count.should == total }
    it { EgridSubregion.where("n2o_emission_factor > 0").count.should == total }
    
    # DEPRECATED
    it { EgridSubregion.where("electricity_emission_factor > 0").count.should == total }
    
    # spot check
    it { akgd.net_generation.should be_within(5).of(5_337_982) }
    it { akgd.co2_emission_factor.should be_within(5e-6).of(0.58099) }
    it { akgd.co2_biogenic_emission_factor.should == nil }
    it { akgd.ch4_emission_factor.should be_within(5e-6).of(0.00031) }
    it { akgd.n2o_emission_factor.should be_within(5e-6).of(0.00104) }
    
    # DEPRECATED
    it { akgd.electricity_emission_factor.should be_within(5e-6).of(0.58234) }
    
    it { akgd.net_generation_units.should == 'megawatt_hours' }
    it { akgd.co2_emission_factor_units.should == 'kilograms_per_kilowatt_hour' }
    it { akgd.co2_biogenic_emission_factor_units.should == nil }
    it { akgd.ch4_emission_factor_units.should == 'kilograms_co2e_per_kilowatt_hour' }
    it { akgd.n2o_emission_factor_units.should == 'kilograms_co2e_per_kilowatt_hour' }
    
    # DEPRECATED
    it { akgd.electricity_emission_factor_units.should == 'kilograms_co2e_per_kilowatt_hour' }
    
    describe '.fallback' do
      let(:fallback) { EgridSubregion.fallback }
      
      it { fallback.name.should == 'fallback' }
      it { fallback.egrid_region.name.should == 'fallback' }
      it { fallback.co2_emission_factor.should be_within(5e-6).of(0.55165) }
      it { fallback.co2_biogenic_emission_factor.should == nil }
      it { fallback.ch4_emission_factor.should be_within(5e-6).of(0.00027) }
      it { fallback.n2o_emission_factor.should be_within(5e-6).of(0.00244) }
      
      # DEPRECATED
      it { fallback.electricity_emission_factor.should be_within(5e-6).of(0.55437) }
    end
  end
end
