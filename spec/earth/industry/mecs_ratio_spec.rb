require 'spec_helper'
require 'earth/industry/mecs_ratio'

describe MecsRatio do
  before :all do
    MecsRatio.auto_upgrade!
  end
  
  describe '.find_by_naics_code_and_census_region_number' do
    before do
      MecsRatio.create! :naics_code => '311', :census_region_number => 1, :energy_per_dollar_of_shipments => 11
      MecsRatio.create! :naics_code => '3112', :census_region_number => 1, :energy_per_dollar_of_shipments => 12
      MecsRatio.create! :naics_code => '311221', :census_region_number => 1, :energy_per_dollar_of_shipments => 13
      MecsRatio.create! :naics_code => '31131', :census_region_number => 1, :energy_per_dollar_of_shipments => 13
      MecsRatio.create! :naics_code => '311', :census_region_number => 2, :energy_per_dollar_of_shipments => 17
      MecsRatio.create! :naics_code => '3112', :census_region_number => 2, :energy_per_dollar_of_shipments => 18
      MecsRatio.create! :naics_code => '311221', :census_region_number => 2, :energy_per_dollar_of_shipments => 19
      MecsRatio.create! :naics_code => '31131', :census_region_number => 2, :energy_per_dollar_of_shipments => 20
    end
    
    it 'finds an exact match' do
      ratio = MecsRatio.find_by_naics_code_and_census_region_number('311221', 2)
      ratio.naics_code.should == '311221'
      ratio.census_region_number.should == 2
    end
    it 'finds a parent category when exact code is not present' do
      ratio = MecsRatio.find_by_naics_code_and_census_region_number('3117', 2)
      ratio.naics_code.should == '311'
      ratio.census_region_number.should == 2
    end
    it 'finds a parent category rather than a sibling category' do
      ratio = MecsRatio.find_by_naics_code_and_census_region_number('311225', 2)
      ratio.naics_code.should == '3112'
      ratio.census_region_number.should == 2
    end
    it 'returns nil if no match found' do
      MecsRatio.find_by_naics_code_and_census_region_number('543211', 2).should be_nil
    end
  end
end
