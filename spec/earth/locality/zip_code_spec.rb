require 'spec_helper'
require "#{Earth::FACTORY_DIR}/zip_code"

describe ZipCode do
  # from acts_as_mappable
  describe '.find_within(radius, units, lat/lng)' do
    it 'returns all zips within radius of the lat/lng' do
      zip1 = FactoryGirl.create :zip_code, :zip1
      zip2 = FactoryGirl.create :zip_code, :zip2
      zip3 = FactoryGirl.create :zip_code, :zip3
      
      ZipCode.near(zip1, 15, :units => :km).should == [zip1, zip2]
    end
  end
  
  describe '.known_subregion' do
    it 'returns all zips with an egrid subregion abbreviation' do
      zip1 = FactoryGirl.create :zip_code, :zip1
      zip2 = FactoryGirl.create :zip_code, :zip2
      ZipCode.known_subregion.count.should > 0
      ZipCode.known_subregion.where(:egrid_subregion_abbreviation => nil).count.should == 0
    end
  end
  
  describe '#country' do
    it 'returns the US' do
      us = Country.find_or_create_by_iso_3166_code 'US'
      ZipCode.new.country.should == us
    end
  end
  
  describe 'Sanity check', :sanity => true do
    it { ZipCode.count.should == 43770 }
    it { ZipCode.where(:state_postal_abbreviation => nil).count.should == 0 }
    it { ZipCode.where('latitude IS NOT NULL AND longitude IS NOT NULL').count.should == 43191 }
    it { ZipCode.where('egrid_subregion_abbreviation IS NOT NULL').count.should == 41333 }
    it { ZipCode.where('climate_division_name IS NOT NULL').count.should == 41358 }
    it { ZipCode.where('population IS NOT NULL').count.should == 33120 }
  end
end
