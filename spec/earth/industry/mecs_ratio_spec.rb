require 'spec_helper'
require 'earth/industry/mecs_ratio'

describe MecsRatio do
  before :all do
    MecsRatio.auto_upgrade!
  end
  
  describe '.find_by_naics_code_and_census_region' do
    before do
      MecsRatio.create! :naics_code => '312', :census_region => '1', :energy_per_dollar_of_shipments => 11
      MecsRatio.create! :naics_code => '3121', :census_region => '1', :energy_per_dollar_of_shipments => 12
      MecsRatio.create! :naics_code => '3122', :census_region => '1', :energy_per_dollar_of_shipments => 13
      MecsRatio.create! :naics_code => '312', :census_region => '2', :energy_per_dollar_of_shipments => 17
      MecsRatio.create! :naics_code => '3121', :census_region => '2', :energy_per_dollar_of_shipments => 18
      MecsRatio.create! :naics_code => '3122', :census_region => '2', :energy_per_dollar_of_shipments => 19
      MecsRatio.create! :naics_code => '312211', :census_region => '2', :energy_per_dollar_of_shipments => 20
    end
    it 'finds an exact match' do
      MecsRatio.find_by_naics_code_and_census_region('312211', '2').
        naics_code.should == '312211'
    end
    it 'finds a parent category by prefix' do
      MecsRatio.find_by_naics_code_and_census_region('312199', '2').
        naics_code.should == '3121'
    end
    it 'returns nil if no match found' do
      MecsRatio.find_by_naics_code_and_census_region('543211', '2').
        should be_nil
    end
  end
end
