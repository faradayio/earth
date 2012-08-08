require 'spec_helper'
require "#{Earth::FACTORY_DIR}/national_transit_database_company"
require "#{Earth::FACTORY_DIR}/national_transit_database_mode"
require "#{Earth::FACTORY_DIR}/national_transit_database_record"

describe NationalTransitDatabaseCompany do
  describe '.rail_companies' do
    it "returns all companies that provide rail service" do
      NationalTransitDatabaseMode.delete_all
      FactoryGirl.create :ntd_mode, :bus
      FactoryGirl.create :ntd_mode, :rail
      FactoryGirl.create :ntd_record, :bus_record
      FactoryGirl.create :ntd_record, :sf_rail_record
      FactoryGirl.create :ntd_company, :bus_company
      muni = FactoryGirl.create :ntd_company, :rail_company
      NationalTransitDatabaseCompany.rail_companies.should == [muni]
    end
  end
  
  describe '#rail_records' do
    it "returns the company's rail transport records" do
      NationalTransitDatabaseMode.delete_all
      FactoryGirl.create :ntd_mode, :rail
      FactoryGirl.create :ntd_record, :ny_rail_record
      muni_record = FactoryGirl.create :ntd_record, :sf_rail_record
      muni = FactoryGirl.create :ntd_company, :rail_company
      muni.rail_records.should == [muni_record]
    end
  end
  
  describe '#rail_passengers' do
    it "calculates the company's rail passengers" do
      NationalTransitDatabaseMode.delete_all
      FactoryGirl.create :ntd_mode, :rail
      FactoryGirl.create :ntd_record, :sf_rail_record
      muni = FactoryGirl.create :ntd_company, :rail_company
      muni.rail_passengers.should == 5000
    end
  end
  
  describe '#rail_passenger_distance' do
    it "calculates the company's rail passenger distance" do
      NationalTransitDatabaseMode.delete_all
      FactoryGirl.create :ntd_mode, :rail
      FactoryGirl.create :ntd_record, :sf_rail_record
      muni = FactoryGirl.create :ntd_company, :rail_company
      muni.rail_passenger_distance.should == 500000
    end
  end
  
  describe '#rail_vehicle_distance' do
    it "calculates the company's vehicle distance" do
      NationalTransitDatabaseMode.delete_all
      FactoryGirl.create :ntd_mode, :rail
      FactoryGirl.create :ntd_record, :sf_rail_record
      muni = FactoryGirl.create :ntd_company, :rail_company
      muni.rail_vehicle_distance.should == 10000
    end
  end
  
  describe '#rail_vehicle_time' do
    it "calculates the company's vehicle time" do
      NationalTransitDatabaseMode.delete_all
      FactoryGirl.create :ntd_mode, :rail
      FactoryGirl.create :ntd_record, :sf_rail_record
      muni = FactoryGirl.create :ntd_company, :rail_company
      muni.rail_vehicle_time.should == 100
    end
  end
  
  describe '#rail_electricity' do
    it "calculates the company's rail electricity use" do
      NationalTransitDatabaseMode.delete_all
      FactoryGirl.create :ntd_mode, :rail
      FactoryGirl.create :ntd_record, :sf_rail_record
      muni = FactoryGirl.create :ntd_company, :rail_company
      muni.rail_electricity.should == 25000
    end
  end
  
  describe '#rail_diesel' do
    it "calculates the company's rail diesel use" do
      NationalTransitDatabaseMode.delete_all
      FactoryGirl.create :ntd_mode, :rail
      FactoryGirl.create :ntd_record, :sf_rail_record
      muni = FactoryGirl.create :ntd_company, :rail_company
      muni.rail_diesel.should be_nil
    end
  end
  
  describe 'Sanity check', :sanity => true do
    it { NationalTransitDatabaseCompany.count.should == 710 }
    it { NationalTransitDatabaseCompany.rail_companies.count.should == 60 }
    
    # spot check
    let(:sf_muni) { NationalTransitDatabaseCompany.find '9015' }
    it { sf_muni.rail_records.count.should == 2 }
    it { sf_muni.rail_passengers.should be_within(5).of(58657463) }
    it { sf_muni.rail_passenger_distance.should be_within(5).of(233748847) }
    it { sf_muni.rail_electricity.should == 58597067 }
    it { sf_muni.rail_diesel.should be_nil }
  end
end
