# encoding: UTF-8

require 'spec_helper'
require 'earth/locality/country'

describe Country do
  describe '.united_states' do
    it 'should return the United States' do
      us = Country.find_or_create_by_iso_3166_code 'US'
      Country.united_states.should == us
    end
  end
  
  describe 'Sanity check', :sanity => true do
    let(:us) { Country.united_states }
    let(:uk) { Country.find 'GB' }
    
    it { Country.count.should == 249 }
    
    describe 'uses UTF-8 encoding' do
      it { Country.find('AX').name.should == "Åland Islands" }
      it { Country.find('CI').name.should == "Côte d'Ivoire" }
    end
    
    it { Country.where('heating_degree_days >= 0 AND cooling_degree_days > 0').count.should == 173 }
    
    describe 'US automobile data' do
      it { us.automobile_urbanity.should == 0.43 }
      it { us.automobile_city_speed.should be_within(5e-5).of(32.0259) }
      it { us.automobile_highway_speed.should be_within(5e-5).of(91.8935) }
      it { us.automobile_trip_distance.should be_within(5e-5).of(16.3348) }
    end
    
    describe 'electricity data' do
      it { Country.where('electricity_emission_factor >= 0').count.should == 136 }
      it { Country.where(:electricity_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour').count.should == 136 }
      it { Country.where('electricity_co2_emission_factor >= 0').count.should == 136 }
      it { Country.where(:electricity_co2_emission_factor_units => 'kilograms_per_kilowatt_hour').count.should == 136 }
      it { Country.where('electricity_ch4_emission_factor >= 0').count.should == 136 }
      it { Country.where(:electricity_ch4_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour').count.should == 136 }
      it { Country.where('electricity_n2o_emission_factor >= 0').count.should == 136 }
      it { Country.where(:electricity_n2o_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour').count.should == 136 }
      it { Country.where('electricity_loss_factor >= 0').count.should == 136 }
      it { Country.maximum(:electricity_loss_factor).should < 0.3 }
      
      # spot checks
      it { us.electricity_emission_factor.should be_within(6e-6).of(0.55437) }
      it { us.electricity_co2_emission_factor.should be_within(5e-6).of(0.55165) }
      it { us.electricity_ch4_emission_factor.should be_within(5e-9).of(0.00027255) }
      it { us.electricity_n2o_emission_factor.should be_within(5e-8).of(0.0024437) }
      it { us.electricity_loss_factor.should be_within(5e-6).of(0.06503) }
      
      it { uk.electricity_emission_factor.should be_within(5e-6).of(0.51020) }
      it { uk.electricity_co2_emission_factor.should be_within(5e-6).of(0.5085) }
      it { uk.electricity_ch4_emission_factor.should be_within(5e-9).of(0.00016875) }
      it { uk.electricity_n2o_emission_factor.should be_within(5e-8).of(0.00152576) }
      it { uk.electricity_loss_factor.should be_within(5e-4).of(0.073) }
    end
    
    describe 'flight data' do
      it { Country.where("flight_route_inefficiency_factor > 0").count.should == 17 }
      it { us.flight_route_inefficiency_factor.should == 1.07 }
      it { uk.flight_route_inefficiency_factor.should == 1.1 }
    end
    
    describe 'lodging data' do
      it { us.lodging_occupancy_rate.should be_within(5e-4).of(0.601) }
      it { us.lodging_natural_gas_intensity.should be_within(5e-4).of(50.719) }
      it { us.lodging_natural_gas_intensity_units.should == 'megajoules_per_room_night' }
    end
    
    describe 'rail data' do
      it { Country.where("rail_passengers > 0").count.should == 26 }
      it { Country.where("rail_trip_distance > 0").count.should == 26 }
      it { Country.where("rail_trip_electricity_intensity > 0").count.should == 26 }
      it { Country.where("rail_trip_diesel_intensity > 0").count.should == 26 }
      it { Country.where("rail_trip_co2_emission_factor > 0").count.should == 26 }
      
      # spot checks
      it { us.rail_passengers.should be_within(10_000).of(4_466_991_391) }
      it { us.rail_trip_distance.should be_within(5e-5).of(12.9952) }
      it { us.rail_speed.should be_within(5e-5).of(32.4972) }
      it { us.rail_trip_electricity_intensity.should be_within(5e-5).of(0.14051) }
      it { us.rail_trip_diesel_intensity.should be_within(5e-5).of(0.01942) }
      it { us.rail_trip_co2_emission_factor.should be_within(5e-5).of(0.0909) }
      
      it { uk.rail_passengers.should == 1352150000 }
      it { uk.rail_trip_distance.should be_within(5e-5).of(40.6904) }
      it { uk.rail_trip_electricity_intensity.should be_within(5e-5).of(0.09) }
      it { uk.rail_trip_diesel_intensity.should be_within(5e-5).of(0.0028) }
      it { uk.rail_trip_co2_emission_factor.should be_within(5e-5).of(0.0458) }
    end
    
    describe '.fallback' do
      let(:fallback) { Country.fallback }
      
      it { fallback.name.should == 'fallback' }
      it { fallback.electricity_emission_factor.should be_within(5e-6).of(0.62609) }
      it { fallback.electricity_emission_factor_units.should == 'kilograms_co2e_per_kilowatt_hour' }
      it { fallback.electricity_co2_emission_factor.should be_within(5e-6).of(0.62354) }
      it { fallback.electricity_co2_emission_factor_units.should == 'kilograms_per_kilowatt_hour' }
      it { fallback.electricity_ch4_emission_factor.should be_within(5e-6).of(0.00021) }
      it { fallback.electricity_ch4_emission_factor_units.should == 'kilograms_co2e_per_kilowatt_hour' }
      it { fallback.electricity_n2o_emission_factor.should be_within(5e-6).of(0.00234) }
      it { fallback.electricity_n2o_emission_factor_units.should == 'kilograms_co2e_per_kilowatt_hour' }
      it { fallback.electricity_loss_factor.should be_within(5e-4).of(0.096) }
      it { fallback.electricity_mix.should == ElectricityMix.fallback }
    end
  end
end
