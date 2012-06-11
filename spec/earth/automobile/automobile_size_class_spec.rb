require 'spec_helper'
require 'earth/automobile/automobile_size_class'

describe AutomobileSizeClass do
  before :all do
    Earth.init :automobile, :load_data_miner => true
  end
  
  describe 'import', :data_miner => true do
    it 'should import data' do
      AutomobileSizeClass.run_data_miner!
    end
  end
  
  describe 'verify', :sanity => true do
    it { AutomobileSizeClass.count.should == 15 }
    it { AutomobileSizeClass.where("fuel_efficiency_city > 0").count.should == AutomobileSizeClass.count }
    it { AutomobileSizeClass.where("fuel_efficiency_highway > 0").count.should == AutomobileSizeClass.count }
    it { AutomobileSizeClass.where("hybrid_fuel_efficiency_city_multiplier > 1.0").count.should == 7 }
    it { AutomobileSizeClass.where("hybrid_fuel_efficiency_highway_multiplier > 1.0").count.should == 7 }
    it { AutomobileSizeClass.where("conventional_fuel_efficiency_city_multiplier < 1.0").count.should == 7 }
    it { AutomobileSizeClass.where("conventional_fuel_efficiency_highway_multiplier < 1.0").count.should == 7 }
  end
  
  describe '.fallback' do
    it { AutomobileSizeClass.fallback.hybrid_fuel_efficiency_city_multiplier.should == 1.651 }
    it { AutomobileSizeClass.fallback.hybrid_fuel_efficiency_highway_multiplier.should == 1.213 }
    it { AutomobileSizeClass.fallback.conventional_fuel_efficiency_city_multiplier.should == 0.987 }
    it { AutomobileSizeClass.fallback.conventional_fuel_efficiency_highway_multiplier.should == 0.996 }
  end
end
