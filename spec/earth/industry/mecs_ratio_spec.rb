require 'spec_helper'
require "#{Earth::FACTORY_DIR}/mecs_ratio"

describe MecsRatio do
  describe '.find_by_naics_code_and_census_region_number' do
    it 'finds an exact match' do
      ratio = FactoryGirl.create :mecs_ratio, :r1111c1
      MecsRatio.find_by_naics_code_and_census_region_number('1111', 1).should == ratio
    end
    it 'finds a parent category when exact code is not present' do
      ratio = FactoryGirl.create :mecs_ratio, :r111c1
      MecsRatio.find_by_naics_code_and_census_region_number('111', 1).should == ratio
    end
    it 'finds same category nationwide when census region is not present' do
      ratio = FactoryGirl.create :mecs_ratio, :r1111
      MecsRatio.find_by_naics_code_and_census_region_number('1111', 1).should == ratio
    end
    it 'keeps looking if energy per dollar of shipments is missing' do
      FactoryGirl.create :mecs_ratio, :r1111c2
      ratio = FactoryGirl.create :mecs_ratio, :r1111
      MecsRatio.find_by_naics_code_and_census_region_number('1111', 2).should == ratio
    end
    it 'finds a parent category rather than a sibling category' do
      FactoryGirl.create :mecs_ratio, :r1112c1
      ratio = FactoryGirl.create :mecs_ratio, :r11c1
      MecsRatio.find_by_naics_code_and_census_region_number('1111', 1).should == ratio
    end
    it 'returns nil if no match found' do
      MecsRatio.find_by_naics_code_and_census_region_number('1111', 1).should be_nil
    end
  end
  
  describe '.find_by_naics_code' do
    it 'finds an exact match' do
      ratio = FactoryGirl.create :mecs_ratio, :r1111
      MecsRatio.find_by_naics_code('1111').should == ratio
    end
    it 'finds a parent category when exact code is not present' do
      ratio = FactoryGirl.create :mecs_ratio, :r111
      MecsRatio.find_by_naics_code('1111').should == ratio
    end
    it 'finds a parent category rather than a sibling category' do
      FactoryGirl.create :mecs_ratio, :r1112
      ratio = FactoryGirl.create :mecs_ratio, :r11
      MecsRatio.find_by_naics_code('1111').should == ratio
    end
    it 'returns nil if no match found' do
      MecsRatio.find_by_naics_code('1111').should be_nil
    end
  end
  
  describe 'Sanity check', :sanity => true do
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
end
