require 'spec_helper'
require 'earth/residence/recs_2009_response'

describe Recs2009Response do
  describe "Sanity check", :sanity => true do
    let(:recs) { Recs2009Response }
    let(:total) { recs.count }
    it { total.should == 12083 }
    
    it { recs.where('year_built > year_occupied').count.should == 0 }
    
    it 'should never have negative values' do
      recs.attribute_names.each do |attribute|
        raise "#{attribute} has negative values" if recs.where("#{attribute} < 0").count > 0
      end
    end
    
    it 'should have at least one non-nil value for each attribute' do
      recs.attribute_names.each do |attribute|
        raise "#{attribute} is always nil" if recs.where("#{attribute} IS NOT NULL").count == 0
      end
    end
    
    it 'should always have a secondary heater if heater portion is present' do
      recs.where('heater_portion IS NOT NULL AND heater_2 IS NULL').count.should == 0
      recs.where('heater_portion IS NULL AND heater_2 IS NOT NULL').count.should == 0
    end
    
    # spot check
    let(:record_87) { recs.find 87 }
    it { record_87.weighting.should be_within(5e-3).of(4357.04) }
    it { record_87.census_region_number.should == 4 }
    it { record_87.census_division_number.should == 8 }
    it { record_87.recs_grouping_id.should == 22 }
    it { record_87.urban_rural.should == 'Rural' }
    it { record_87.metro_micro.should == 'Metro' }
    it { record_87.climate_region_id.should == 1 }
    it { record_87.climate_zone_id.should == 1 }
    it { record_87.hdd_2009.should be_within(5e-3).of(4311.67) }
    it { record_87.cdd_2009.should be_within(5e-5).of(20.5556) }
    it { record_87.hdd_avg.should be_within(5e-3).of(4053.33) }
    it { record_87.cdd_avg.should be_within(5e-5).of(79.4444) }
    it { record_87.building_type.should == 'Single-family Detached' }
    it { record_87.converted_house.should == nil }
    it { record_87.condo_coop.should == nil }
    it { record_87.apartments.should == nil }
    it { record_87.year_built.should == 1979 }
    it { record_87.year_occupied.should == 1995 }
    it { record_87.building_floors.should == 2 }
    it { record_87.levels.should == 2 }
    it { record_87.area.should be_within(5e-4).of(281.682) }
    it { record_87.rooms.should == 7 }
    it { record_87.bedrooms.should == 3 }
    it { record_87.bathrooms.should == 2 }
    it { record_87.half_baths.should == 0 }
    it { record_87.other_rooms.should == 4 }
    it { record_87.attic_rooms.should == 0 }
    it { record_87.basement_rooms.should == 1 }
    it { record_87.pool.should == false }
    it { record_87.shaded.should == true }
    it { record_87.garage_type.should == 'Attached' }
    it { record_87.garage_size.should == 'Two-car' }
    it { record_87.slab.should == true }
    it { record_87.crawlspace.should == false }
    it { record_87.basement_type.should == 'Finished' }
    it { record_87.wall_material.should == 'Siding (Aluminum, Vinyl, Steel)' }
    it { record_87.roof_material.should == 'Composition Shingles' }
    it { record_87.attic_type.should == 'Unfinished' }
    it { record_87.windows.should == 35 }
    it { record_87.window_panes.should == 2 }
    it { record_87.sliding_doors.should == 1 }
    it { record_87.insulation.should == 'Good' }
    it { record_87.drafty.should == 'Some of the time' }
    it { record_87.high_ceiling.should == true }
    it { record_87.heater.should == 'Heating Stove' }
    it { record_87.heater_age.should == 12 }
    it { record_87.heater_fuel.should == 'Wood' }
    it { record_87.heater_shared.should == false }
    it { record_87.heater_thermostats.should == 0 }
    it { record_87.heater_portion.should be_within(5e-2).of(1.0) }
    it { record_87.heater_2.should == 'Built-In Electric Units' }
    it { record_87.heater_2_fuel.should == 'Electricity' }
    it { record_87.heater_3.should == nil }
    it { record_87.heater_3_fuel.should == nil }
    it { record_87.heater_4.should == nil }
    it { record_87.heater_4_fuel.should == nil }
    it { record_87.heater_5.should == nil }
    it { record_87.heater_5_fuel.should == nil }
    it { record_87.heater_6.should == nil }
    it { record_87.heater_6_fuel.should == nil }
    it { record_87.cooler_central_age.should == nil }
    it { record_87.cooler_central_shared.should == nil }
    it { record_87.cooler_ac_units.should == 0 }
    it { record_87.cooler_ac_age.should == nil }
    it { record_87.cooler_ac_energy_star.should == nil }
    it { record_87.fans.should == 3 }
    it { record_87.water_heaters_tankless.should == 0 }
    it { record_87.water_heaters_storage.should == 2 }
    it { record_87.water_heater.should == 'Storage' }
    it { record_87.water_heater_fuel.should == 'Solar' }
    it { record_87.water_heater_age.should == 7 }
    it { record_87.water_heater_size.should == 'Large (50 gallons or more)' }
    it { record_87.water_heater_shared.should == false }
    it { record_87.water_heater_2.should == 'Storage' }
    it { record_87.water_heater_2_fuel.should == 'Electricity' }
    it { record_87.water_heater_2_age.should == 1 }
    it { record_87.water_heater_2_size.should == 'Medium (31 to 49 gallons)' }
    it { record_87.pool_fuel.should == nil }
    it { record_87.hot_tub_fuel.should == 'Electricity' }
    it { record_87.lights_high_use.should == 0 }
    it { record_87.lights_high_use_efficient.should == 0 }
    it { record_87.lights_med_use.should == 4 }
    it { record_87.lights_med_use_efficient.should == 0 }
    it { record_87.lights_low_use.should == 5 }
    it { record_87.lights_low_use_efficient.should == 0 }
    it { record_87.lights_outdoor.should == 0 }
    it { record_87.lights_outdoor_efficient.should == 0 }
    it { record_87.cooking_fuel.should == 'Electricity' }
    it { record_87.stoves.should == 0 }
    it { record_87.stove_fuel.should == nil }
    it { record_87.cooktops.should == 1 }
    it { record_87.cooktop_fuel.should == 'Electricity' }
    it { record_87.ovens.should == 1 }
    it { record_87.oven_type.should == 'Manual self-cleaning' }
    it { record_87.oven_fuel.should == 'Electricity' }
    it { record_87.outdoor_grill_fuel.should == 'Propane/LPG' }
    it { record_87.indoor_grill_fuel.should == nil }
    it { record_87.toaster.should == false }
    it { record_87.coffee.should == true }
    it { record_87.fridges.should == 1 }
    it { record_87.fridge_type.should == 'Full-size, 2 doors, freezer above' }
    it { record_87.fridge_size.should == 'Medium (15 to 18 cu ft)' }
    it { record_87.fridge_defrost.should == 'Frost-free' }
    it { record_87.fridge_door_ice.should == true }
    it { record_87.fridge_age.should == 7 }
    it { record_87.fridge_energy_star.should == true }
    it { record_87.fridge_2_type.should == nil }
    it { record_87.fridge_2_size.should == nil }
    it { record_87.fridge_2_defrost.should == nil }
    it { record_87.fridge_2_age.should == nil }
    it { record_87.fridge_2_energy_star.should == nil }
    it { record_87.fridge_3_type.should == nil }
    it { record_87.fridge_3_size.should == nil }
    it { record_87.fridge_3_defrost.should == nil }
    it { record_87.fridge_3_age.should == nil }
    it { record_87.fridge_3_energy_star.should == nil }
    it { record_87.freezers.should == 0 }
    it { record_87.freezer_type.should == nil }
    it { record_87.freezer_size.should == nil }
    it { record_87.freezer_defrost.should == nil }
    it { record_87.freezer_age.should == nil }
    it { record_87.freezer_2_type.should == nil }
    it { record_87.freezer_2_size.should == nil }
    it { record_87.freezer_2_defrost.should == nil }
    it { record_87.freezer_2_age.should == nil }
    it { record_87.dishwasher_age.should == 7 }
    it { record_87.dishwasher_energy_star.should == true }
    it { record_87.washer_type.should == 'Top-loading' }
    it { record_87.washer_age.should == 12 }
    it { record_87.washer_energy_star.should == nil }
    it { record_87.dryer_fuel.should == 'Electricity' }
    it { record_87.dryer_age.should == 12 }
    it { record_87.tvs.should == 3 }
    it { record_87.tv_size.should == '37 inches or more' }
    it { record_87.tv_type.should == 'Projection' }
    it { record_87.tv_theater.should == false }
    it { record_87.tv_2_size.should == '21 to 26 inches' }
    it { record_87.tv_2_type.should == 'CRT' }
    it { record_87.tv_2_theater.should == false }
    it { record_87.tv_3_size.should == '21 to 26 inches' }
    it { record_87.tv_3_type.should == 'LCD' }
    it { record_87.tv_3_theater.should == false }
    it { record_87.computers.should == 2 }
    it { record_87.computer_type.should == 'Desktop' }
    it { record_87.computer_monitor.should == 'CRT' }
    it { record_87.computer_2_type.should == 'Desktop' }
    it { record_87.computer_2_monitor.should == 'CRT' }
    it { record_87.computer_3_type.should == nil }
    it { record_87.computer_3_monitor.should == nil }
    it { record_87.internet.should == true }
    it { record_87.printers.should == 3 }
    it { record_87.fax.should == false }
    it { record_87.copier.should == false }
    it { record_87.well_pump.should == true }
    it { record_87.engine_block_heater.should == false }
    it { record_87.aquarium.should == false }
    it { record_87.stereo.should == true }
    it { record_87.cordless_phone.should == true }
    it { record_87.answering_machine.should == true }
    it { record_87.tools.should == 2 }
    it { record_87.electronics.should == 12 }
    it { record_87.home_business.should == true }
    it { record_87.home_during_week.should == true }
    it { record_87.telecommuting.should == 0 }
    it { record_87.unusual_activities.should == false }
    it { record_87.heat_area.should be_within(5e-4).of(196.118) }
    it { record_87.heat_rooms.should == 5 }
    it { record_87.heat_attic_portion.should be_within(5e-2).of(0.0) }
    it { record_87.heat_basement_portion.should == be_within(5e-2).of(1.0) }
    it { record_87.heat_garage.should == false }
    it { record_87.heat_temp_day.should == 66 }
    it { record_87.heat_temp_night.should == 58 }
    it { record_87.heat_temp_away.should == 66 }
    it { record_87.heat_auto_adjust_day.should == nil }
    it { record_87.heat_auto_adjust_night.should == nil }
    it { record_87.cool_area.should be_within(5e-2).of(0.0) }
    it { record_87.cool_rooms.should == 0 }
    it { record_87.cool_attic_portion.should be_within(5e-2).of(0.0) }
    it { record_87.cool_basement_portion.should be_within(5e-2).of(0.0) }
    it { record_87.cool_garage.should == false }
    it { record_87.cool_temp_day.should == nil }
    it { record_87.cool_temp_night.should == nil }
    it { record_87.cool_temp_away.should == nil }
    it { record_87.cool_auto_adjust_day.should == nil }
    it { record_87.cool_auto_adjust_night.should == nil }
    it { record_87.cooler_central_use.should == nil }
    it { record_87.cooler_ac_use.should == nil }
    it { record_87.fan_use.should == 'Turned on occasionally' }
    it { record_87.humidifier_use.should == 5 }
    it { record_87.dehumidifier_use.should == nil }
    it { record_87.oven_use.should == 13 }
    it { record_87.microwave_use.should == 'About half of meals and snacks' }
    it { record_87.microwave_defrost.should == true }
    it { record_87.cooking_frequency.should == 61 }
    it { record_87.fridge_2_use.should == nil }
    it { record_87.fridge_3_use.should == nil }
    it { record_87.dishwasher_use.should == 35 }
    it { record_87.washer_use.should == 13 }
    it { record_87.washer_temp_wash.should == 'Warm' }
    it { record_87.washer_temp_rinse.should == 'Cold' }
    it { record_87.dryer_use.should == 'Every load of laundry' }
    it { record_87.tv_weekday_use.should == 5 }
    it { record_87.tv_weekend_use.should == 8 }
    it { record_87.tv_2_weekday_use.should == 2 }
    it { record_87.tv_2_weekend_use.should == 2 }
    it { record_87.tv_3_weekday_use.should == 1 }
    it { record_87.tv_3_weekend_use.should == 1 }
    it { record_87.computer_use.should == 12 }
    it { record_87.computer_idle.should == 'Turned off' }
    it { record_87.computer_2_use.should == 12 }
    it { record_87.computer_2_idle.should == 'Sleep / standby' }
    it { record_87.computer_3_use.should == nil }
    it { record_87.computer_3_idle.should == nil }
    it { record_87.tool_charging.should == 'Always charging' }
    it { record_87.tool_vampires.should == 'Chargers never unplugged' }
    it { record_87.electronic_charging.should == 'Both' }
    it { record_87.electronic_vampires.should == 'Chargers never unplugged' }
    it { record_87.energy_audit.should == false }
    it { record_87.energy_audit_year.should == nil }
    it { record_87.energy_audit_incent.should == nil }
    it { record_87.energy_audit_incent_year.should == nil }
    it { record_87.insulation_added.should == true }
    it { record_87.insulation_added_year.should == 2008 }
    it { record_87.insulation_incent.should == 'None' }
    it { record_87.insulation_incent_year.should == nil }
    it { record_87.caulking_added.should == true }
    it { record_87.caulking_added_year.should == 2008 }
    it { record_87.caulking_incent.should == 'None' }
    it { record_87.caulking_incent_year.should == nil }
    it { record_87.windows_replaced.should == 'All' }
    it { record_87.windows_incent.should == 'None' }
    it { record_87.windows_incent_year.should == nil }
    it { record_87.heater_maintained.should == false }
    it { record_87.heater_replaced.should == nil }
    it { record_87.heater_incent.should == nil }
    it { record_87.heater_incent_year.should == nil }
    it { record_87.cooler_central_maintained.should == nil }
    it { record_87.cooler_central_replaced.should == nil }
    it { record_87.cooler_central_incent.should == nil }
    it { record_87.cooler_central_incent_year.should == nil }
    it { record_87.cooler_ac_replaced.should == nil }
    it { record_87.cooler_ac_incent.should == nil }
    it { record_87.cooler_ac_incent_year.should == nil }
    it { record_87.water_heater_blanket.should == true }
    it { record_87.water_heater_incent.should == 'None' }
    it { record_87.water_heater_incent_year.should == nil }
    it { record_87.lights_replaced.should == nil }
    it { record_87.lights_incent.should == nil }
    it { record_87.lights_incent_year.should == nil }
    it { record_87.dishwasher_replaced.should == nil }
    it { record_87.dishwasher_incent.should == nil }
    it { record_87.dishwasher_incent_year.should == nil }
    it { record_87.fridge_replaced.should == nil }
    it { record_87.fridge_incent.should == nil }
    it { record_87.fridge_incent_year.should == nil }
    it { record_87.freezer_replaced.should == nil }
    it { record_87.freezer_incent.should == nil }
    it { record_87.freezer_incent_year.should == nil }
    it { record_87.washer_replaced.should == nil }
    it { record_87.washer_incent.should == nil }
    it { record_87.washer_incent_year.should == nil }
    it { record_87.renewable_energy.should == nil }
    it { record_87.own_rent.should == 'Owner' }
    it { record_87.sex.should == 'Male' }
    it { record_87.employment.should == 'Not employed / retired' }
    it { record_87.live_with_spouse.should == true }
    it { record_87.race.should == 'White' }
    it { record_87.latino.should == false }
    it { record_87.education.should == "Master's degree" }
    it { record_87.household_size.should == 2 }
    it { record_87.member_1_age.should == 63 }
    it { record_87.member_2_age.should == 62 }
    it { record_87.member_3_age.should == nil }
    it { record_87.member_4_age.should == nil }
    it { record_87.member_5_age.should == nil }
    it { record_87.member_6_age.should == nil }
    it { record_87.member_7_age.should == nil }
    it { record_87.member_8_age.should == nil }
    it { record_87.member_9_age.should == nil }
    it { record_87.member_10_age.should == nil }
    it { record_87.member_11_age.should == nil }
    it { record_87.member_12_age.should == nil }
    it { record_87.member_13_age.should == nil }
    it { record_87.member_14_age.should == nil }
    it { record_87.income.should == 77500 }
    it { record_87.income_employment.should == true }
    it { record_87.income_retirement.should == true }
    it { record_87.income_ssi.should == false }
    it { record_87.income_welfare.should == false }
    it { record_87.income_investment.should == true }
    it { record_87.income_other.should == true }
    it { record_87.poverty_100.should == false }
    it { record_87.poverty_150.should == false }
    it { record_87.public_housing_authority.should == nil }
    it { record_87.low_rent.should == nil }
    it { record_87.food_stamps.should == false }
    it { record_87.pays_electricity_heat.should == 'Paid by the household' }
    it { record_87.pays_electricity_water.should == 'Paid by the household' }
    it { record_87.pays_electricity_cooking.should == 'Paid by the household' }
    it { record_87.pays_electricity_cool.should == nil }
    it { record_87.pays_electricity_lighting.should == 'Paid by the household' }
    it { record_87.pays_natural_gas_heat.should == nil }
    it { record_87.pays_natural_gas_water.should == nil }
    it { record_87.pays_natural_gas_cooking.should == nil }
    it { record_87.pays_natural_gas_other.should == nil }
    it { record_87.pays_fuel_oil.should == nil }
    it { record_87.pays_propane.should == nil }
    it { record_87.electricity_heat.should == true }
    it { record_87.electricity_heat_2.should == true }
    it { record_87.electricity_cool.should == false }
    it { record_87.electricity_water.should == true }
    it { record_87.electricity_cooking.should == true }
    it { record_87.electricity_other.should == true }
    it { record_87.natural_gas_heat.should == false }
    it { record_87.natural_gas_heat_2.should == false }
    it { record_87.natural_gas_water.should == false }
    it { record_87.natural_gas_cooking.should == false }
    it { record_87.natural_gas_other.should == false }
    it { record_87.propane_heat.should == false }
    it { record_87.propane_heat_2.should == false }
    it { record_87.propane_water.should == false }
    it { record_87.propane_cooking.should == false }
    it { record_87.propane_other.should == true }
    it { record_87.fuel_oil_heat.should == false }
    it { record_87.fuel_oil_heat_2.should == false }
    it { record_87.fuel_oil_water.should == false }
    it { record_87.fuel_oil_other.should == false }
    it { record_87.kerosene_heat.should == false }
    it { record_87.kerosene_heat_2.should == false }
    it { record_87.kerosene_water.should == false }
    it { record_87.kerosene_other.should == false }
    it { record_87.wood_heat.should == true }
    it { record_87.wood_heat_2.should == false }
    it { record_87.wood_water.should == false }
    it { record_87.wood_other.should == false }
    it { record_87.solar_heat.should == false }
    it { record_87.solar_heat_2.should == false }
    it { record_87.solar_water.should == true }
    it { record_87.solar_other.should == false }
    it { record_87.other_heat.should == false }
    it { record_87.other_heat_2.should == false }
    it { record_87.other_water.should == false }
    it { record_87.other_cooking.should == false }
    it { record_87.energy.should be_within(5e-2).of(55948.6) }
    it { record_87.energy_cost.should == 1572 }
    it { record_87.electricity.should be_within(5e-3).of(15542) }
    it { record_87.electricity_cost.should == 1572 }
    it { record_87.natural_gas.should be_within(5e-3).of(0.0) }
    it { record_87.natural_gas_cost.should == 0 }
    it { record_87.propane.should be_within(5e-3).of(0.0) }
    it { record_87.propane_cost.should == 0 }
    it { record_87.fuel_oil.should be_within(5e-3).of(0.0) }
    it { record_87.fuel_oil_cost.should == 0 }
    it { record_87.kerosene.should be_within(5e-3).of(0.0) }
    it { record_87.kerosene_cost.should == 0 }
    it { record_87.wood.should be_within(5e-1).of(126607) }
  end
end
