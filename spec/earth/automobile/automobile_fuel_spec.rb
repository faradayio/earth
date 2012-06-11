require 'spec_helper'
require 'earth/automobile'

describe AutomobileFuel do
  let(:fallback) { AutomobileFuel.fallback }
  
  describe 'import', :data_miner => true do
    before do
      Earth.init :automobile, :load_data_miner => true
    end
    
    it 'should import data without problems' do
      AutomobileFuel.run_data_miner!
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it { AutomobileFuel.count.should == 12 }
    it { AutomobileFuel.where(:distance_key => nil).count.should == 0 }
    it { AutomobileFuel.where("annual_distance >= 0").count.should == AutomobileFuel.count }
    it { AutomobileFuel.where("energy_content >= 0").count.should == AutomobileFuel.count }
    it { AutomobileFuel.where("co2_emission_factor >= 0").count.should == AutomobileFuel.count - 1 }
    it { AutomobileFuel.where("co2_biogenic_emission_factor >= 0").count.should == AutomobileFuel.count - 1 }
    it { AutomobileFuel.where("ch4_emission_factor >= 0").count.should == AutomobileFuel.count }
    it { AutomobileFuel.where("n2o_emission_factor >= 0").count.should == AutomobileFuel.count }
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
        fuel.common_name.should == 'gasoline'
        fuel.annual_distance.should == AutomobileFuel.gasoline.annual_distance
        fuel.co2_emission_factor.should == AutomobileFuel.gasoline.co2_emission_factor
        fuel.ch4_emission_factor.should == AutomobileFuel.gasoline.ch4_emission_factor
        fuel.n2o_emission_factor.should == AutomobileFuel.gasoline.n2o_emission_factor
      end
    end
  end
  
  describe '.diesel' do
    it { AutomobileFuel.diesel.should == AutomobileFuel.find('diesel') }
  end
  
  describe '.gasoline' do
    it { AutomobileFuel.gasoline.should == AutomobileFuel.find('gasoline') }
  end
  
  describe '.fallback_blend_portion' do
    it { AutomobileFuel.fallback_blend_portion.should be_within(1e-5).of(0.01260) }
  end
  
  describe '.fallback' do
    it { AutomobileFuel.fallback.name.should == 'fallback' }
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
  
  describe '#non_liquid?' do
    it { AutomobileFuel.where(:energy_content_units => 'megajoules_per_litre').first.non_liquid?.should == false }
    it { AutomobileFuel.where("energy_content_units != 'megajoules_per_litre'").first.non_liquid?.should == true }
  end
  
  describe '#same_as?' do
    it { AutomobileFuel.find_by_code('G').same_as?(AutomobileFuel.find_by_code 'G').should == true }
    it { AutomobileFuel.find_by_code('G').same_as?(AutomobileFuel.find_by_code 'R').should == true }
    it { AutomobileFuel.find_by_code('G').same_as?(AutomobileFuel.find_by_code 'D').should == false }
  end
end
