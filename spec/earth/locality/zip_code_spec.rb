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
    it 'should have all the data' do
      ZipCode.count.should == 43770
    end
    it 'has a state for most zip codes' do
      ZipCode.where('state_postal_abbreviation IS NOT NULL').count.should == 43734
    end
    
    it 'has a lat and lng for most zip codes' do
      ZipCode.where('latitude IS NOT NULL AND longitude IS NOT NULL').count.should == 43191
    end
    
    it 'has an eGRID subregion for most zip codes' do
      ZipCode.where('egrid_subregion_abbreviation IS NOT NULL').count.should == 41297
    end
    
    it 'has a climate division for most zip codes' do
      ZipCode.where('climate_division_name IS NOT NULL').count.should == 41358
    end
    
    it 'has a population for all 33120 Census 2010 ZCTAs' do
      ZipCode.where('population IS NOT NULL').count.should == 33120
    end
  end
  
  describe '#country' do
    before do
      require 'earth/locality/country'
    end
    
    it 'should return the US' do
      ZipCode.first.country.should == Country.united_states
      ZipCode.last.country.should == Country.united_states
    end
  end
  
  describe '#latitude_longitude' do
    it 'should return the lat and lng as an array of strings' do
      ZipCode.first.latitude_longitude.should == [nil, nil]
      ZipCode.last.latitude_longitude.should == ['55.875767', '-131.46633']
    end
  end
end
