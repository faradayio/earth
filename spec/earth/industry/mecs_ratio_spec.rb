require 'spec_helper'
require 'earth/industry/mecs_ratio'
require 'earth/industry/industry' # MecsRatio's custom find by method calls an Industry method

describe MecsRatio do
  describe 'verify imported data', :sanity => true do
    it 'should have all the data' do
      MecsRatio.count.should == 395
    end
    it 'spot checks the data' do
      apparel = MecsRatio.find_by_naics_code '315'
      apparel.census_region_number.should be_nil
      apparel.energy_per_dollar_of_shipments.should be_within(5e-6).of(0.5.kbtus.to(:megajoules))
      apparel.energy_per_dollar_of_shipments_units.should == 'megajoules'
    end
  end
  
  describe '.find_by_naics_code_and_census_region_number' do
    it 'finds an exact match' do
      MecsRatio.find_by_naics_code_and_census_region_number('311221', 2).
        name.should == '311221-2'
    end
    it 'finds a parent category when exact code is not present' do
      MecsRatio.find_by_naics_code_and_census_region_number('3117', 2).
        name.should == '311-2'
    end
    it 'finds same category nationwide when census region is not present' do
      MecsRatio.find_by_naics_code_and_census_region_number('311221', 5).
        name.should == '311221-'
    end
    it 'looks nationwide and at parent codes if energy per dollar of shipments is missing' do
      MecsRatio.find_by_naics_code_and_census_region_number('313', 4).
        name.should == '313-'
    end
    it 'finds a parent category rather than a sibling category' do
      MecsRatio.find_by_naics_code_and_census_region_number('311225', 2).
        name.should == '3112-2'
    end
    it 'returns nil if no match found' do
      MecsRatio.find_by_naics_code_and_census_region_number('543211', 2).
        should be_nil
    end
  end
  
  describe '.find_by_naics_code' do
    it 'finds an exact match' do
      MecsRatio.find_by_naics_code('311221').name.should == '311221-'
    end
    it 'finds a parent category when exact code is not present' do
      MecsRatio.find_by_naics_code('3117').name.should == '311-'
    end
    it 'finds a parent category rather than a sibling category' do
      MecsRatio.find_by_naics_code('311225').name.should == '3112-'
    end
    it 'returns nil if no match found' do
      MecsRatio.find_by_naics_code('543211').should be_nil
    end
  end
end
