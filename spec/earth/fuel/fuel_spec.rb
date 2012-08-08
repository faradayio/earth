require 'spec_helper'
require "#{Earth::FACTORY_DIR}/fuel"
require "#{Earth::FACTORY_DIR}/fuel_year"

describe Fuel do
  describe '#latest_fuel_year' do
    it {
      FactoryGirl.create :fuel_year, :gas_2008
      FactoryGirl.create :fuel_year, :gas_2007
      gas = FactoryGirl.create :fuel, :gas
      gas.latest_fuel_year.should == FuelYear.find('Gasoline 2008')
    }
  end
  
  describe '#energy_content' do
    it "returns energy content if present" do
      diesel = FactoryGirl.create :fuel, :diesel
      diesel.energy_content.should be_within(5e-6).of(39)
      diesel.energy_content_units.should == 'megajoules_per_litre'
    end
    
    it "delegates method to FuelYear if energy content missing" do
      FactoryGirl.create :fuel_year, :gas_2008
      gas = FactoryGirl.create :fuel, :gas
      gas.energy_content.should be_within(5e-6).of(35)
      gas.energy_content_units.should == 'megajoules_per_litre'
    end
  end
  
  describe '#carbon_content' do
    it "returns carbon content if present" do
      diesel = FactoryGirl.create :fuel, :diesel
      diesel.carbon_content.should be_within(5e-6).of(19)
      diesel.carbon_content_units.should == 'grams_per_megajoule'
    end
    
    it "delegates method to FuelYear if carbon content missing" do
      FactoryGirl.create :fuel_year, :gas_2008
      gas = FactoryGirl.create :fuel, :gas
      gas.carbon_content.should be_within(5e-6).of(18)
      gas.carbon_content_units.should == 'grams_per_megajoule'
    end
  end
  
  describe '#co2_emission_factor' do
    it "returns co2 emission factor if present" do
      diesel = FactoryGirl.create :fuel, :diesel
      diesel.co2_emission_factor.should be_within(5e-6).of(2.717)
      diesel.co2_emission_factor_units.should == 'kilograms_per_litre'
    end
    
    it "delegates method to FuelYear if co2 emission factor missing" do
      FactoryGirl.create :fuel_year, :gas_2008
      gas = FactoryGirl.create :fuel, :gas
      gas.co2_emission_factor.should be_within(5e-6).of(2.31)
      gas.co2_emission_factor_units.should == 'kilograms_per_litre'
    end
  end
  
  describe '#co2_biogenic_emission_factor' do
    it "returns co2 biogenic emission factor if present" do
      diesel = FactoryGirl.create :fuel, :diesel
      diesel.co2_biogenic_emission_factor.should be_within(5e-6).of(0.0)
      diesel.co2_biogenic_emission_factor_units.should == 'kilograms_per_litre'
    end
    
    it "delegates method to FuelYear if co2 biogenic emission factor missing" do
      FactoryGirl.create :fuel_year, :gas_2008
      gas = FactoryGirl.create :fuel, :gas
      gas.co2_biogenic_emission_factor.should be_within(5e-6).of(0.0)
      gas.co2_biogenic_emission_factor_units.should == 'kilograms_per_litre'
    end
  end
  
  describe 'Sanity check', :sanity => true do
    let(:unvarying) { Fuel.where('biogenic_fraction IS NOT NULL') }
    let(:biogenic) { Fuel.where(:biogenic_fraction => 1) }
    let(:fossil) { Fuel.where(:biogenic_fraction => 0) }
    
    it { Fuel.count.should == 23 }
    it { biogenic.count.should == 3 }
    it { fossil.count.should == 11 }
    it { unvarying.where('energy_content > 0').count.should == unvarying.count }
    it { unvarying.where('carbon_content >= 0').count.should == unvarying.count }
    it { unvarying.where(:oxidation_factor => 1).count.should == unvarying.count }
    it { biogenic.where(:co2_emission_factor => 0).count.should == biogenic.count }
    it { fossil.where('co2_emission_factor >= 0').count.should == fossil.count }
    it { biogenic.where('co2_biogenic_emission_factor > 0').count.should == biogenic.count }
    it { fossil.where(:co2_biogenic_emission_factor => 0).count.should == fossil.count }
    
    it 'should have a record for district heat' do
      district_heat = Fuel.find 'District Heat'
      district_heat.co2_emission_factor.should be_within(5e-6).of(0.07598)
    end
    
    # spot check
    it { Fuel.find('Motor Gasoline').co2_emission_factor.should be_within(5e-6).of(2.34183) }
    it { Fuel.find('Distillate Fuel Oil No. 2').co2_emission_factor.should be_within(5e-6).of(2.70219) }
  end
end
