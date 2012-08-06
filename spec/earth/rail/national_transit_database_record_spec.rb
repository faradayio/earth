require 'spec_helper'
require "#{Earth::FACTORY_DIR}/national_transit_database_mode"
require "#{Earth::FACTORY_DIR}/national_transit_database_record"

describe NationalTransitDatabaseRecord do
  describe '.rail_records' do
    it "should return all rail records" do
      NationalTransitDatabaseMode.delete_all
      FactoryGirl.create :ntd_mode, :bus
      FactoryGirl.create :ntd_mode, :rail
      FactoryGirl.create :ntd_record, :bus_record
      rail_record = FactoryGirl.create :ntd_record, :sf_rail_record
      NationalTransitDatabaseRecord.rail_records.should == [rail_record]
    end
  end
  
  describe 'Sanity check', :sanity => true do
    it { NationalTransitDatabaseRecord.count.should == 1310 }
    it { NationalTransitDatabaseRecord.rail_records.count.should == 81 }
    
    # spot check
    let(:sf_muni_lr) { NationalTransitDatabaseRecord.find '9015 LR DO' }
    it { sf_muni_lr.passengers.should be_within(50).of(50744862) }
    it { sf_muni_lr.passenger_distance.should be_within(500).of(217848220) }
    it { sf_muni_lr.electricity.should be_within(50).of(54532320) }
    it { sf_muni_lr.diesel.should be_nil }
    
    let(:sf_muni_bus) { NationalTransitDatabaseRecord.find '9015 MB DO' }
    it { sf_muni_bus.diesel.should be_within(50).of(19087261) }
  end
end
