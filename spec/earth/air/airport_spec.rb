# encoding: UTF-8

require 'spec_helper'
require 'earth/air/airport'

describe Airport do
  describe "verify imported data", :sanity => true do
    it "should have all the data" do
      Airport.count.should == 5324
    end
    
    it "should use utf-8 encoding" do
      Airport.find('PDA').city.should == 'Puerto Inírida'
    end
    
    it "should have name" do
      Airport.where(:name => nil).count.should == 0
    end
    
    it "should have city" do
      Airport.where(:city => nil).count.should == 0
      Airport.where(:city => '').count.should == 0
    end
    
    it "should have country code" do
      Airport.where(:country_iso_3166_code => nil).count.should == 0
    end
    
    it "should have lat/lng" do
      Airport.where(:latitude => nil).count.should == 0
      Airport.where(:longitude => nil).count.should == 0
    end
    
    # FIXME TODO check for duplicate cities in same country
  end
end
