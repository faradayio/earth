require 'spec_helper'
require 'earth/locality/petroleum_administration_for_defense_district'

describe PetroleumAdministrationForDefenseDistrict do
  let(:padd) { PetroleumAdministrationForDefenseDistrict }
  
  describe '#name' do
    it 'describes a PADD that is a district' do 
      test = padd.new(:district_code => 1, :district_name => 'East Coast')
      test.name.should == 'PAD District 1 (East Coast)'
    end
    it 'describes a PADD that is a subdistric' do
      test = padd.new(:district_code => 1, :district_name => 'East Coast', :subdistrict_code => 'A', :subdistrict_name => 'New England')
      test.name.should == 'PAD District 1 (East Coast) Subdistrict 1A (New England)'
    end
  end
  
  describe 'Sanity check', :sanity => true do
    it { padd.count.should == 7 }
  end
end
