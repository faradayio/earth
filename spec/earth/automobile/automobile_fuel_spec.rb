require 'spec_helper'
require "#{Earth::FACTORY_DIR}/automobile_fuel"

describe AutomobileFuel do
  describe '.diesel' do
    it "should return diesel" do
      AutomobileFuel.delete_all
      diesel = FactoryGirl.create :automobile_fuel, :diesel
      AutomobileFuel.diesel.should == diesel
    end
  end
  
  describe '.gasoline' do
    it "should return gasoline" do
      AutomobileFuel.delete_all
      gas = FactoryGirl.create :automobile_fuel, :gas
      AutomobileFuel.gasoline.should == gas
    end
  end
  
  describe '.fallback_blend_portion' do
    it "should return diesel's share of total US gasoline and diesel consumption" do
      AutomobileFuel.delete_all
      diesel = FactoryGirl.create :automobile_fuel, :diesel
      gas = FactoryGirl.create :automobile_fuel, :gas
      AutomobileFuel.fallback_blend_portion.should be_within(5e-2).of(0.1)
    end
  end
  
  describe '#non_liquid?' do
    it "should return true if energy content units are megajoules per litre" do
      AutomobileFuel.delete_all
      gas = FactoryGirl.create :automobile_fuel, :gas
      cng = FactoryGirl.create :automobile_fuel, :cng
      
      gas.non_liquid?.should == false
      cng.non_liquid?.should == true
    end
  end
  
  describe '#same_as?(other_auto_fuel)' do
    it "should consider all grades of gasoline as the same" do
      AutomobileFuel.delete_all
      gas = FactoryGirl.create :automobile_fuel, :gas
      regular = FactoryGirl.create :automobile_fuel, :regular
      premium = FactoryGirl.create :automobile_fuel, :premium
      
      gas.same_as?(gas).should == true
      gas.same_as?(regular).should == true
      gas.same_as?(premium).should == true
      regular.same_as?(premium).should == true
    end
    
    it "should consider identical non-gasoline fuels as the same" do
      AutomobileFuel.delete_all
      b5 = FactoryGirl.create :automobile_fuel, :b5
      b20 = FactoryGirl.create :automobile_fuel, :b20
      
      b5.same_as?(b5).should == true
      b5.same_as?(b20).should == false
    end
  end
  
  describe '#suffix' do
    it "returns 'DIESEL' for diesel and biodiesel fuels" do
      %w{ D BP-B5 BP-B20 BP-B100 }.each do |fuel_code|
        AutomobileFuel.new(:code => fuel_code).suffix.should == 'DIESEL'
      end
    end
    
    it "returns 'FFV' for ethanol" do
      AutomobileFuel.new(:code => 'E').suffix.should == 'FFV'
    end
    
    it "returns 'CNG' for cng" do
      AutomobileFuel.new(:code => 'C').suffix.should == 'CNG'
    end
  end
  
  describe 'Sanity check', :sanity => true do
    let(:total) { AutomobileFuel.count }
    
    it { total.should == 12 }
    it { AutomobileFuel.where(:distance_key => nil).count.should == 0 }
    it { AutomobileFuel.where("annual_distance >= 0").count.should == total }
    it { AutomobileFuel.where("energy_content >= 0").count.should == total }
    it { AutomobileFuel.where("co2_emission_factor >= 0").count.should == total - 1 }
    it { AutomobileFuel.where("co2_biogenic_emission_factor >= 0").count.should == total - 1 }
    it { AutomobileFuel.where("ch4_emission_factor >= 0").count.should == total }
    it { AutomobileFuel.where("n2o_emission_factor >= 0").count.should == total }
    it { AutomobileFuel.where("total_consumption >= 0").count.should == 2 }
    
    it { AutomobileFuel.find('gasoline').annual_distance.should be_within(0.1).of(17568.6) }
    it { AutomobileFuel.find('gasoline').energy_content.should be_within(1e-5).of(34.6272) }
    it { AutomobileFuel.find('gasoline').co2_emission_factor.should be_within(1e-6).of(2.34183) }
    it { AutomobileFuel.find('gasoline').ch4_emission_factor.should be_within(1e-8).of(4.2548e-4) }
    it { AutomobileFuel.find('gasoline').n2o_emission_factor.should be_within(1e-6).of(5.7340e-3) }
    
    it { AutomobileFuel.find('gasoline').annual_distance_units.should == 'kilometres' }
    it { AutomobileFuel.find('gasoline').energy_content_units.should == 'megajoules_per_litre' }
    it { AutomobileFuel.find('gasoline').co2_emission_factor_units.should == 'kilograms_per_litre' }
    it { AutomobileFuel.find('gasoline').ch4_emission_factor_units.should == 'kilograms_co2e_per_kilometre' }
    it { AutomobileFuel.find('gasoline').n2o_emission_factor_units.should == 'kilograms_co2e_per_kilometre' }
    
    it { AutomobileFuel.find('diesel').annual_distance.should be_within(0.1).of(22410.2) }
    it { AutomobileFuel.find('diesel').energy_content.should be_within(1e-5).of(38.5491) }
    it { AutomobileFuel.find('diesel').co2_emission_factor.should be_within(1e-6).of(2.70219) }
    it { AutomobileFuel.find('diesel').ch4_emission_factor.should be_within(1e-9).of(1.3887e-5) }
    it { AutomobileFuel.find('diesel').n2o_emission_factor.should be_within(1e-8).of(2.5812e-4) }
    
    it { AutomobileFuel.find('gasoline').total_consumption.should > 455_000_000_000 }
    it { AutomobileFuel.find('diesel').total_consumption.should > 5_800_000_000 }
    
    it { AutomobileFuel.find('Electricity').energy_content.should == 3.6 }
    it { AutomobileFuel.find('Electricity').co2_emission_factor.should == nil }
    it { AutomobileFuel.find('Electricity').co2_biogenic_emission_factor.should == nil }
    it { AutomobileFuel.find('Electricity').ch4_emission_factor.should == 0 }
    it { AutomobileFuel.find('Electricity').n2o_emission_factor.should == 0 }
    
    it "all grades of gasoline should have same annual distance and emission factors" do
      AutomobileFuel.where("name LIKE '%gasoline'").each do |fuel|
        fuel.family.should == 'gasoline'
        fuel.annual_distance.should == AutomobileFuel.gasoline.annual_distance
        fuel.co2_emission_factor.should == AutomobileFuel.gasoline.co2_emission_factor
        fuel.ch4_emission_factor.should == AutomobileFuel.gasoline.ch4_emission_factor
        fuel.n2o_emission_factor.should == AutomobileFuel.gasoline.n2o_emission_factor
      end
    end
    
    describe '.fallback' do
      let(:fallback) { AutomobileFuel.fallback }
      
      it { fallback.name.should == 'fallback' }
      it { fallback.base_fuel.should == Fuel.find('Motor Gasoline') }
      it { fallback.blend_fuel.should == Fuel.find('Distillate Fuel Oil No. 2') }
      it { fallback.blend_portion.should be_within(1e-5).of(0.01260) }
      
      it { fallback.annual_distance.should be_within(0.1).of(17629.6) }
      it { fallback.energy_content.should be_within(1e-6).of(34.6766) }
      it { fallback.co2_emission_factor.should be_within(1e-6).of(2.34637) }
      it { fallback.co2_biogenic_emission_factor.should == 0.0 }
      it { fallback.ch4_emission_factor.should be_within(1e-8).of(4.203e-4) }
      it { fallback.n2o_emission_factor.should be_within(1e-8).of(5.665e-3) }
      
      it { fallback.energy_content_units.should == 'megajoules_per_litre' }
      it { fallback.co2_emission_factor_units.should == 'kilograms_per_litre' }
      it { fallback.co2_biogenic_emission_factor_units.should == 'kilograms_per_litre' }
      it { fallback.ch4_emission_factor_units.should == 'kilograms_co2e_per_kilometre' }
      it { fallback.n2o_emission_factor_units.should == 'kilograms_co2e_per_kilometre' }
    end
  end
end
