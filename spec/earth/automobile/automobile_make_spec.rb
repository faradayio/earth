require 'spec_helper'
require 'earth/automobile/automobile_make'

describe AutomobileMake do
  before :all do
    Earth.init :automobile, :load_data_miner => true, :skip_parent_associations => :true
    
    # MakeYear fe from CAFE data
    @honda = AutomobileMake.find('Honda')
    @honda_years = AutomobileMakeYear.where(:make_name => 'Honda')
    
    # MakeYear fe from average of variants
    @acura = AutomobileMake.find('Acura')
    @acura_years = AutomobileMakeYear.where(:make_name => 'Acura')
  end
  
  describe 'import', :data_miner => true do
    it 'should import data' do
      AutomobileMake.run_data_miner!
      AutomobileMake.count.should == AutomobileMake.connection.select_value("SELECT COUNT(DISTINCT make_name) FROM #{AutomobileMakeYear.quoted_table_name}")
    end
  end
  
  describe '#make_years' do
    it { @honda.make_years.sort.should == @honda_years.sort }
    it { @acura.make_years.sort.should == @acura_years.sort }
  end
  
  describe '#fuel_efficiency' do
    it { @honda.fuel_efficiency.should_not == nil }
    it { @honda.fuel_efficiency.should == @honda_years.weighted_average(:fuel_efficiency) }
    
    it { @acura.fuel_efficiency.should_not == nil }
    it { @acura.fuel_efficiency.should == @acura_years.weighted_average(:fuel_efficiency) }
  end
  
  describe '#fuel_efficiency_units' do
    it { @honda.fuel_efficiency_units.should == 'kilometres_per_litre' }
    it { @acura.fuel_efficiency_units.should == 'kilometres_per_litre' }
  end
end
