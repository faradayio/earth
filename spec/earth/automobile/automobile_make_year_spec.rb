require 'spec_helper'
require 'earth/automobile/automobile_make_year'

describe AutomobileMakeYear do
  let(:amy) { AutomobileMakeYear }
  
  describe 'Sanity check', :sanity => true do
    let(:total) { amy.count }
    
    it { total.should == 1276 }
    it { amy.where("fuel_efficiency > 0").count.should == total }
    it { amy.find("Honda 2011").fuel_efficiency.should be_within(1e-4).of(13.34186) }
    it { amy.find("Honda 2012").fuel_efficiency.should be_within(1e-5).of(12.17321) }
    
    it 'has proper weightings' do
      amy.connection.select_values("SELECT DISTINCT year FROM #{amy.quoted_table_name}").each do |year|
        amy.where(:year => year).first.weighting.should == AutomobileYear.weighting(year)
      end
    end
  end
end
