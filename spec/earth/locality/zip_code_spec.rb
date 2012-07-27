require 'spec_helper'
require 'earth/locality/zip_code'

describe ZipCode do
  describe 'when importing data', :data_miner => true do
    before do
      Earth.init :locality, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it 'imports data' do
      ZipCode.run_data_miner!
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it { ZipCode.count.should == 43770 }
    it { ZipCode.where(:state_postal_abbreviation => nil).count.should == 0 }
    it { ZipCode.where('latitude IS NOT NULL AND longitude IS NOT NULL').count.should == 43191 }
    it { ZipCode.where('egrid_subregion_abbreviation IS NOT NULL').count.should == 41333 }
    it { ZipCode.where('climate_division_name IS NOT NULL').count.should == 41358 }
    it { ZipCode.where('population IS NOT NULL').count.should == 33120 }
  end
  
  # from acts_as_mappable
  describe '.find_within' do
    it { ZipCode.find_within(15, :units => :kms, :origin => ZipCode.find('05753').latitude_longitude).count.should == 7 }
  end
  
  describe '.known_subregion' do
    it { ZipCode.known_subregion.where(:egrid_subregion_abbreviation => nil).count.should == 0 }
  end
  
  describe '#country' do
    before do
      require 'earth/locality/country'
    end
    
    it 'returns the US' do
      ZipCode.new.country.should == Country.united_states
    end
  end
  
  describe '#latitude_longitude' do
    it 'returns an array of nils for missing lat/lon' do
      ZipCode.new.latitude_longitude.should == [nil, nil]
    end
    it 'should return the lat and lng as an array of strings' do
      zip = ZipCode.new :latitude => '43.005895', :longitude => '-71.013202'
      zip.latitude_longitude.should == ['43.005895', '-71.013202']
    end
  end
end
