require 'spec_helper'
require 'earth/industry/mecs_ratio'

describe MecsRatio do
  before :all do
    MecsRatio.auto_upgrade!
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
