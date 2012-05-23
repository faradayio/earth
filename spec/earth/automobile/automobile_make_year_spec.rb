require 'spec_helper'
require 'earth/automobile/automobile_make_year'

describe AutomobileMakeYear do
  before :all do
    Earth.init :automobile, :load_data_miner => true, :skip_parent_associations => :true
  end
  
  describe 'import', :data_miner => true do
    it 'should import data' do
      AutomobileMakeYear.run_data_miner!
      AutomobileMakeYear.count.should == AutomobileMakeYear.connection.select_value("SELECT COUNT(DISTINCT make_name, year) FROM #{AutomobileMakeModelYearVariant.quoted_table_name}")
    end
  end
  
  describe 'verify imported data' do
    it { AutomobileMakeYear.where("fuel_efficiency > 0").count.should == AutomobileMakeYear.count }
    it { AutomobileMakeYear.find("Honda 2011").fuel_efficiency.should be_within(0.0001).of(AutomobileMakeYearFleet.where(:make_name => 'Honda', :year => 2011).weighted_average(:fuel_efficiency, :weighted_by => :volume)) }
    it { AutomobileMakeYear.find("Honda 2012").fuel_efficiency.should be_within(0.00001).of(AutomobileMakeModelYearVariant.where(:make_name => 'Honda', :year => 2012).average(:fuel_efficiency)) }
    
    AutomobileMakeYear.connection.select_values("SELECT DISTINCT year FROM #{AutomobileMakeYear.quoted_table_name}").each do |year|
      it { AutomobileMakeYear.where(:year => year).first.weighting.should == AutomobileYear.weighting(year) }
    end
  end
end
