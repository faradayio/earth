require 'spec_helper'
require "#{Earth::FACTORY_DIR}/automobile_fuel"
require "#{Earth::FACTORY_DIR}/automobile_make"
require "#{Earth::FACTORY_DIR}/automobile_make_model"
require "#{Earth::FACTORY_DIR}/automobile_make_model_year"
require "#{Earth::FACTORY_DIR}/automobile_model"

describe AutomobileMakeModel do
  let(:amm) { AutomobileMakeModel }
  let(:ammy) { AutomobileMakeModelYear }
  
  describe '.custom_find' do
    it 'finds diesel models' do
      amm.delete_all
      AutomobileMake.delete_all
      AutomobileModel.delete_all
      AutomobileFuel.delete_all
      
      FactoryGirl.create :amm, :vw_jetta
      FactoryGirl.create :amm, :vw_jetta_diesel
      vw = FactoryGirl.create :automobile_make, :vw
      jetta = FactoryGirl.create :automobile_model, :jetta
      
      %w{ diesel b5 b20 b100 }.each do |fuel|
        f = FactoryGirl.create :automobile_fuel, fuel.to_sym
        amm.custom_find(
          { :make => vw, :model => jetta, :automobile_fuel => f }
        ).name.should == 'Volkswagen JETTA DIESEL'
      end
    end
    
    it 'finds flex-fuel models' do
      amm.delete_all
      AutomobileMake.delete_all
      AutomobileModel.delete_all
      AutomobileFuel.delete_all
      
      FactoryGirl.create :amm, :ford_f150_ffv
      ford = FactoryGirl.create :automobile_make, :ford
      f150 = FactoryGirl.create :automobile_model, :f150
      e85 = FactoryGirl.create :automobile_fuel, :e85
      
      amm.custom_find(
        { :make => ford, :model => f150, :automobile_fuel => e85 }
      ).name.should == 'Ford F150 FFV'
    end
    
    it 'finds cng models' do
      amm.delete_all
      AutomobileMake.delete_all
      AutomobileModel.delete_all
      AutomobileFuel.delete_all
      
      FactoryGirl.create :amm, :honda_civic_cng
      honda = FactoryGirl.create :automobile_make, :honda
      civic = FactoryGirl.create :automobile_model, :civic
      cng = FactoryGirl.create :automobile_fuel, :cng
      
      amm.custom_find(
        { :make => honda, :model => civic, :automobile_fuel => cng }
      ).name.should == 'Honda CIVIC CNG'
    end
    
    it 'ignores fuel if it does not help' do
      amm.delete_all
      AutomobileMake.delete_all
      AutomobileModel.delete_all
      AutomobileFuel.delete_all
      
      FactoryGirl.create :amm, :vw_jetta
      FactoryGirl.create :amm, :vw_jetta_diesel
      vw = FactoryGirl.create :automobile_make, :vw
      jetta = FactoryGirl.create :automobile_model, :jetta
      cng = FactoryGirl.create :automobile_fuel, :cng
      
      amm.custom_find(
        { :make => vw, :model => jetta, :automobile_fuel => cng }
      ).name.should == 'Volkswagen JETTA'
    end
  end
  
  describe '#model_years' do
    it "returns all the associated model years" do
      ammy.delete_all
      amm.delete_all
      
      FactoryGirl.create :ammy, :honda_civic_2000
      FactoryGirl.create :ammy, :honda_civic_cng_2000
      FactoryGirl.create :ammy, :honda_civic_cng_2001
      
      amm = FactoryGirl.create :amm, :honda_civic_cng
      amm.model_years.should == ammy.where(:make_name => 'Honda', :model_name => 'CIVIC CNG')
    end
  end
  
  describe 'Sanity check', :sanity => true do
    let(:total) { amm.count }
    let(:civic) { amm.where(:name => "Honda Civic").first }
    let(:civic_cng) { amm.where(:name => "Honda Civic CNG").first }
    let(:f150_ffv) { amm.where(:name => "Ford F150 FFV").first }
    
    it { total.should == 2353 }
    
    it { amm.where(:fuel_code => nil).count.should == 0 }
    it { amm.where("fuel_efficiency_city > 0").count.should == total }
    it { amm.where("fuel_efficiency_highway > 0").count.should == total }
    it { amm.where("alt_fuel_code IS NOT NULL").count.should == 157 }
    it { amm.where("alt_fuel_efficiency_city > 0").count.should == 157 }
    it { amm.where("alt_fuel_efficiency_highway > 0").count.should == 157 }
    it { amm.where(:type_name => nil).count.should == 0 }
    
    # spot checks
    it { civic.fuel_code.should == 'G' }
    it { civic.fuel_efficiency_city.should be_within(1e-4).of(10.884) }
    it { civic.fuel_efficiency_city_units.should == 'kilometres_per_litre' }
    it { civic.fuel_efficiency_highway.should be_within(1e-4).of(14.2857) }
    it { civic.fuel_efficiency_highway_units.should == 'kilometres_per_litre' }
    
    it { civic.alt_fuel_code.should == nil }
    it { civic.alt_fuel_efficiency_city.should == nil }
    it { civic.alt_fuel_efficiency_city_units.should == nil }
    it { civic.alt_fuel_efficiency_highway.should == nil }
    it { civic.alt_fuel_efficiency_highway_units.should == nil }
    
    it { civic.type_name.should == 'Passenger cars' }
    
    it { civic_cng.fuel_code.should == 'C' }
    it { civic_cng.fuel_efficiency_city.should be_within(1e-4).of(10.5237) }
    it { civic_cng.fuel_efficiency_city_units.should == 'kilometres_per_litre' }
    it { civic_cng.fuel_efficiency_highway.should be_within(1e-4).of(14.1971) }
    it { civic_cng.fuel_efficiency_highway_units.should == 'kilometres_per_litre' }
    
    it { f150_ffv.fuel_code.should == 'R' }
    it { f150_ffv.fuel_efficiency_city.should be_within(1e-4).of(5.9628) }
    it { f150_ffv.fuel_efficiency_city_units.should == 'kilometres_per_litre' }
    it { f150_ffv.fuel_efficiency_highway.should be_within(1e-4).of(8.0427) }
    it { f150_ffv.fuel_efficiency_highway_units.should == 'kilometres_per_litre' }
    
    it { f150_ffv.alt_fuel_code.should == 'E' }
    it { f150_ffv.alt_fuel_efficiency_city.should be_within(1e-4).of(4.3744) }
    it { f150_ffv.alt_fuel_efficiency_city_units.should == 'kilometres_per_litre' }
    it { f150_ffv.alt_fuel_efficiency_highway.should be_within(1e-4).of(5.842) }
    it { f150_ffv.alt_fuel_efficiency_highway_units.should == 'kilometres_per_litre' }
    
    it { f150_ffv.type_name.should == 'Light-duty trucks' }
  end
end
