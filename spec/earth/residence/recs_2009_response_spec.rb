require 'spec_helper'
require 'earth/residence/recs_2009_response'

describe Recs2009Response do
  describe "Sanity check", :sanity => true do
    let(:recs) { Recs2009Response }
    let(:total) { recs.count }
    it { total.should == 12083 }
    
    it { recs.where('year_built > year_occupied').count.should == 0 }
    
    it 'should have at least one non-nil value for each attribute' do
      recs.attribute_names.each do |attribute|
        raise "#{attribute} is always nil" if recs.where("#{attribute} IS NOT NULL").count == 0
      end
    end
    
    # spot check
    let(:record_17) { recs.find 17 }
    it { record_17.weighting.should be_within(5e-2).of(15622.3) }
    it { record_17.census_region_number.should == 3 }
    it { record_17.census_division_number.should == 5 }
    it { record_17.recs_grouping_id.should == 16 }
    it { record_17.urban_rural.should == 'Rural' }
    it { record_17.metro_micro.should == 'Micro' }
    it { record_17.climate_region_id.should == 4 }
    it { record_17.climate_zone_id.should == 4 }
    it { record_17.hdd_2009.should be_within(5e-3).of(1901.67) }
    it { record_17.cdd_2009.should be_within(5e-4).of(891.111) }
    it { record_17.hdd_avg.should be_within(5e-3).of(1888.89) }
    it { record_17.cdd_avg.should be_within(5e-4).of(911.667) }
    it { record_17.building_type.should == 'Single-family Detached' }
    it { record_17.converted_house.should == nil }
    it { record_17.condo_coop.should == nil }
    it { record_17.apartments.should == nil }
    it { record_17.year_built.should == 1963 }
    it { record_17.year_occupied.should == 1965 }
    it { record_17.building_floors.should == 1 }
    it { record_17.levels.should == 1 }
    it { record_17.area.should be_within(5e-4).of(137.682) }
    it { record_17.rooms.should == 6 }
    it { record_17.bedrooms.should == 3 }
    it { record_17.bathrooms.should == 1 }
    it { record_17.half_baths.should == 0 }
    it { record_17.other_rooms.should == 3 }
    it { record_17.attic_rooms.should == nil }
    it { record_17.basement_rooms.should == nil }
    it { record_17.shaded.should == true }
    it { record_17.garage.should == nil }
    it { record_17.garage_size.should == nil }
    it { record_17.garage_heated.should == nil }
    it { record_17.garage_cooled.should == nil }
    it { record_17.pool_fuel.should == nil }
    it { record_17.hot_tub_fuel.should == nil }
    it { record_17.slab.should == false }
    it { record_17.crawlspace.should == true }
    it { record_17.basement.should == nil }
    it { record_17.wall_material.should == 'Siding (Aluminum, Vinyl, Steel)' }
    it { record_17.roof_material.should == 'Composition Shingles' }
    it { record_17.attic.should == 'Unfinished' }
    it { record_17.windows.should == 13 }
    it { record_17.window_panes.should == 1 }
    it { record_17.sliding_doors.should == 0 }
    it { record_17.insulation.should == 'Poor' }
    it { record_17.drafty.should == 'Most of the time' }
    it { record_17.high_ceiling.should == false }
    it { record_17.heater.should == nil }
    it { record_17.heater_age.should == nil }
    it { record_17.heater_fuel.should == nil }
    it { record_17.heater_shared.should == nil }
    it { record_17.heater_thermostats.should == nil }
    it { record_17.heater_portion.should == nil }
    it { record_17.heater_2.should == nil }
    it { record_17.heater_2_fuel.should == nil }
    it { record_17.heater_3.should == nil }
    it { record_17.heater_3_fuel.should == nil }
    it { record_17.heater_4.should == nil }
    it { record_17.heater_4_fuel.should == nil }
    it { record_17.heater_5.should == nil }
    it { record_17.heater_5_fuel.should == nil }
    it { record_17.heater_6.should == nil }
    it { record_17.heater_6_fuel.should == nil }
    it { record_17.heater_unused.should == nil }
    it { record_17.heater_unused_fuel.should == nil }
    it { record_17.cooler_central_age.should == nil }
    it { record_17.cooler_central_shared.should == nil }
    it { record_17.cooler_acs.should == 1 }
    it { record_17.cooler_ac_age.should == 25 }
    it { record_17.cooler_ac_energy_star.should == nil }
    it { record_17.cooler_unused.should == nil }
    it { record_17.fans.should == 0 }
    it { record_17.water_heater.should == nil }
    it { record_17.water_heater_fuel.should == nil }
    it { record_17.water_heater_size.should == nil }
    it { record_17.water_heater_age.should == nil }
    it { record_17.water_heater_shared.should == nil }
    it { record_17.water_heater_2.should == nil }
    it { record_17.water_heater_2_fuel.should == nil }
    it { record_17.water_heater_2_size.should == nil }
    it { record_17.water_heater_2_age.should == nil }
    it { record_17.storage_water_heaters.should == 0 }
    it { record_17.tankless_water_heaters.should == 0 }
    it { record_17.lights_high_use.should == 0 }
    it { record_17.lights_high_use_efficient.should == nil }
    it { record_17.lights_med_use.should == 0 }
    it { record_17.lights_med_use_efficient.should == nil }
    it { record_17.lights_low_use.should == 1 }
    it { record_17.lights_low_use_efficient.should == 1 }
    it { record_17.lights_outdoor.should == 0 }
    it { record_17.lights_outdoor_efficient.should == nil }
    it { record_17.cooking_fuel.should == nil }
    it { record_17.stoves.should == 0 }
    it { record_17.stove_fuel.should == nil }
    it { record_17.cooktops.should == 0 }
    it { record_17.cooktop_fuel.should == nil }
    it { record_17.ovens.should == 0 }
    it { record_17.oven_type.should == nil }
    it { record_17.oven_fuel.should == nil }
    it { record_17.outdoor_grill_fuel.should == nil }
    it { record_17.indoor_grill_fuel.should == nil }
    it { record_17.toaster.should == true }
    it { record_17.coffee.should == false }
    it { record_17.fridges.should == 1 }
    it { record_17.fridge_type.should == 'Half-size / compact' }
    it { record_17.fridge_size.should == 'Half-size / compact' }
    it { record_17.fridge_defrost.should == 'Manual' }
    it { record_17.fridge_door_ice.should == false }
    it { record_17.fridge_age.should == 3 }
    it { record_17.fridge_energy_star.should == true }
    it { record_17.fridge_2_type.should == nil }
    it { record_17.fridge_2_size.should == nil }
    it { record_17.fridge_2_defrost.should == nil }
    it { record_17.fridge_2_age.should == nil }
    it { record_17.fridge_2_energy_star.should == nil }
    it { record_17.fridge_3_type.should == nil }
    it { record_17.fridge_3_size.should == nil }
    it { record_17.fridge_3_defrost.should == nil }
    it { record_17.fridge_3_age.should == nil }
    it { record_17.fridge_3_energy_star.should == nil }
    it { record_17.freezers.should == nil }
    it { record_17.freezer_type.should == nil }
    it { record_17.freezer_size.should == nil }
    it { record_17.freezer_defrost.should == nil }
    it { record_17.freezer_age.should == nil }
    it { record_17.freezer_2_type.should == nil }
    it { record_17.freezer_2_size.should == nil }
    it { record_17.freezer_2_defrost.should == nil }
    it { record_17.freezer_2_age.should == nil }
    it { record_17.dishwasher_age.should == nil }
    it { record_17.dishwasher_energy_star.should == nil }
    it { record_17.washer.should == nil }
    it { record_17.washer_age.should == nil }
    it { record_17.washer_energy_star.should == nil }
    it { record_17.dryer_fuel.should == nil }
    it { record_17.dryer_age.should == nil }
    it { record_17.tvs.should == 1 }
    it { record_17.tv_size.should == '21 to 26 inches' }
    it { record_17.tv_type.should == 'CRT' }
    it { record_17.tv_theater.should == false }
    it { record_17.tv_2_size.should == nil }
    it { record_17.tv_2_type.should == nil }
    it { record_17.tv_2_theater.should == nil }
    it { record_17.tv_3_size.should == nil }
    it { record_17.tv_3_type.should == nil }
    it { record_17.tv_3_theater.should == nil }
    it { record_17.computers.should == 0 }
    it { record_17.computer_type.should == nil }
    it { record_17.computer_monitor.should == nil }
    it { record_17.computer_2_type.should == nil }
    it { record_17.computer_2_monitor.should == nil }
    it { record_17.computer_3_type.should == nil }
    it { record_17.computer_3_monitor.should == nil }
    it { record_17.internet.should == nil }
    it { record_17.printers.should == nil }
    it { record_17.fax.should == false }
    it { record_17.copier.should == false }
    it { record_17.well_pump.should == false }
    it { record_17.engine_block_heater.should == nil }
    it { record_17.aquarium.should == false }
    it { record_17.stereo.should == false }
    it { record_17.cordless_phone.should == false }
    it { record_17.answering_machine.should == false }
    it { record_17.tools.should == 0 }
    it { record_17.electronics.should == 0 }
    it { record_17.home_business.should == false }
    it { record_17.home_during_week.should == true }
    it { record_17.telecommuting.should == nil }
    it { record_17.unusual_activities.should == false }
    it { record_17.heat_area.should == 0 }
    it { record_17.heat_rooms.should == nil }
    it { record_17.heat_attic_portion.should be_within(5e-4).of(0.0) }
    it { record_17.heat_basement_portion.should == nil }
    it { record_17.heat_temp_day.should == nil }
    it { record_17.heat_temp_night.should == nil }
    it { record_17.heat_temp_away.should == nil }
    it { record_17.heat_auto_adjust_day.should == nil }
    it { record_17.heat_auto_adjust_night.should == nil }
    it { record_17.cool_area.should be_within(5e-5).of(22.9471) }
    it { record_17.cool_rooms.should == nil }
    it { record_17.cool_attic_portion.should be_within(5e-4).of(0.0) }
    it { record_17.cool_basement_portion.should == nil }
    it { record_17.cool_temp_day.should == nil }
    it { record_17.cool_temp_night.should == nil }
    it { record_17.cool_temp_away.should == nil }
    it { record_17.cool_auto_adjust_day.should == nil }
    it { record_17.cool_auto_adjust_night.should == nil }
    it { record_17.cooler_central_use.should == nil }
    it { record_17.cooler_ac_use.should == 'Turned on occasionally' }
    it { record_17.fan_use.should == nil }
    it { record_17.humidifier_use.should == nil }
    it { record_17.dehumidifier_use.should == nil }
    it { record_17.oven_use.should == nil }
    it { record_17.microwave_use.should == 'Very little' }
    it { record_17.microwave_defrost.should == false }
    it { record_17.cooking_frequency.should == 13 }
    it { record_17.fridge_2_use.should == nil }
    it { record_17.fridge_3_use.should == nil }
    it { record_17.dishwasher_use.should == nil }
    it { record_17.washer_use.should == nil }
    it { record_17.washer_temp_wash.should == nil }
    it { record_17.washer_temp_rinse.should == nil }
    it { record_17.dryer_use.should == nil }
    it { record_17.tv_weekday_use.should == 1 }
    it { record_17.tv_weekend_use.should == 1 }
    it { record_17.tv_2_weekday_use.should == nil }
    it { record_17.tv_2_weekend_use.should == nil }
    it { record_17.tv_3_weekday_use.should == nil }
    it { record_17.tv_3_weekend_use.should == nil }
    it { record_17.computer_use.should == nil }
    it { record_17.computer_idle.should == nil }
    it { record_17.computer_2_use.should == nil }
    it { record_17.computer_2_idle.should == nil }
    it { record_17.computer_3_use.should == nil }
    it { record_17.computer_3_idle.should == nil }
    it { record_17.tool_charging.should == nil }
    it { record_17.tool_vampires.should == nil }
    it { record_17.electronic_charging.should == nil }
    it { record_17.electronic_vampires.should == nil }
    it { record_17.energy_audit.should == false }
    it { record_17.energy_audit_year.should == nil }
    it { record_17.energy_audit_incent.should == nil }
    it { record_17.energy_audit_incent_year.should == nil }
    it { record_17.insulation_added.should == false }
    it { record_17.insulation_added_year.should == nil }
    it { record_17.insulation_incent.should == nil }
    it { record_17.insulation_incent_year.should == nil }
    it { record_17.windows_replaced.should == 'None' }
    it { record_17.windows_incent.should == nil }
    it { record_17.windows_incent_year.should == nil }
    it { record_17.caulking_added.should == false }
    it { record_17.caulking_added_year.should == nil }
    it { record_17.caulking_incent.should == nil }
    it { record_17.caulking_incent_year.should == nil }
    it { record_17.heater_maintained.should == nil }
    it { record_17.heater_replaced.should == nil }
    it { record_17.heater_incent.should == nil }
    it { record_17.heater_incent_year.should == nil }
    it { record_17.cooler_central_maintained.should == nil }
    it { record_17.cooler_central_replaced.should == nil }
    it { record_17.cooler_central_incent.should == nil }
    it { record_17.cooler_central_incent_year.should == nil }
    it { record_17.cooler_ac_replaced.should == nil }
    it { record_17.cooler_ac_incent.should == nil }
    it { record_17.cooler_ac_incent_year.should == nil }
    it { record_17.water_heater_blanket.should == nil }
    it { record_17.water_heater_incent.should == nil }
    it { record_17.water_heater_incent_year.should == nil }
    it { record_17.lights_replaced.should == true }
    it { record_17.lights_incent.should == 'None' }
    it { record_17.lights_incent_year.should == nil }
    it { record_17.dishwasher_replaced.should == nil }
    it { record_17.dishwasher_incent.should == nil }
    it { record_17.dishwasher_incent_year.should == nil }
    it { record_17.fridge_replaced.should == true }
    it { record_17.fridge_incent.should == 'None' }
    it { record_17.fridge_incent_year.should == nil }
    it { record_17.freezer_replaced.should == nil }
    it { record_17.freezer_incent.should == nil }
    it { record_17.freezer_incent_year.should == nil }
    it { record_17.washer_replaced.should == nil }
    it { record_17.washer_incent.should == nil }
    it { record_17.washer_incent_year.should == nil }
    it { record_17.renewable_energy.should == nil }
    it { record_17.own_rent.should == 'Owner' }
    it { record_17.sex.should == 'Male' }
    it { record_17.employment.should == 'Not employed / retired' }
    it { record_17.live_with_spouse.should == false }
    it { record_17.race.should == 'Black / African American' }
    it { record_17.latino.should == false }
    it { record_17.education.should == 'Kindergarten to grade 12' }
    it { record_17.household_size.should == 1 }
    it { record_17.member_1_age.should == 46 }
    it { record_17.member_2_age.should == nil }
    it { record_17.member_3_age.should == nil }
    it { record_17.member_4_age.should == nil }
    it { record_17.member_5_age.should == nil }
    it { record_17.member_6_age.should == nil }
    it { record_17.member_7_age.should == nil }
    it { record_17.member_8_age.should == nil }
    it { record_17.member_9_age.should == nil }
    it { record_17.member_10_age.should == nil }
    it { record_17.member_11_age.should == nil }
    it { record_17.member_12_age.should == nil }
    it { record_17.member_13_age.should == nil }
    it { record_17.member_14_age.should == nil }
    it { record_17.income.should == 1250 }
    it { record_17.income_employment.should == false }
    it { record_17.income_retirement.should == false }
    it { record_17.income_ssi.should == false }
    it { record_17.income_welfare.should == false }
    it { record_17.income_investment.should == false }
    it { record_17.income_other.should == false }
    it { record_17.poverty_100.should == true }
    it { record_17.poverty_150.should == true }
    it { record_17.public_housing_authority.should == nil }
    it { record_17.low_rent.should == nil }
    it { record_17.food_stamps.should == true }
    it { record_17.pays_electricity_heat.should == nil }
    it { record_17.pays_electricity_water.should == nil }
    it { record_17.pays_electricity_cooking.should == nil }
    it { record_17.pays_electricity_cool.should == nil }
    it { record_17.pays_electricity_lighting.should == 'Paid by the household' }
    it { record_17.pays_natural_gas_heat.should == nil }
    it { record_17.pays_natural_gas_water.should == nil }
    it { record_17.pays_natural_gas_cooking.should == nil }
    it { record_17.pays_natural_gas_other.should == nil }
    it { record_17.pays_fuel_oil.should == nil }
    it { record_17.pays_propane.should == nil }
    it { record_17.electricity_heat.should == false }
    it { record_17.electricity_heat_2.should == false }
    it { record_17.electricity_cool.should == true }
    it { record_17.electricity_water.should == false }
    it { record_17.electricity_cooking.should == false }
    it { record_17.electricity_other.should == true }
    it { record_17.natural_gas_heat.should == false }
    it { record_17.natural_gas_heat_2.should == false }
    it { record_17.natural_gas_water.should == false }
    it { record_17.natural_gas_cooking.should == false }
    it { record_17.natural_gas_other.should == false }
    it { record_17.propane_heat.should == false }
    it { record_17.propane_heat_2.should == false }
    it { record_17.propane_water.should == false }
    it { record_17.propane_cooking.should == false }
    it { record_17.propane_other.should == false }
    it { record_17.fuel_oil_heat.should == false }
    it { record_17.fuel_oil_heat_2.should == false }
    it { record_17.fuel_oil_water.should == false }
    it { record_17.fuel_oil_other.should == false }
    it { record_17.kerosene_heat.should == false }
    it { record_17.kerosene_heat_2.should == false }
    it { record_17.kerosene_water.should == false }
    it { record_17.kerosene_other.should == false }
    it { record_17.wood_heat.should == false }
    it { record_17.wood_heat_2.should == false }
    it { record_17.wood_water.should == false }
    it { record_17.wood_other.should == false }
    it { record_17.solar_heat.should == false }
    it { record_17.solar_heat_2.should == false }
    it { record_17.solar_water.should == false }
    it { record_17.solar_other.should == false }
    it { record_17.other_heat.should == false }
    it { record_17.other_heat_2.should == false }
    it { record_17.other_water.should == false }
    it { record_17.other_cooking.should == false }
    it { record_17.energy.should be_within(5e-3).of(7484.57) }
    it { record_17.energy_cost.should == 271 }
    it { record_17.electricity.should be_within(5e-3).of(2079) }
    it { record_17.electricity_cost.should == 271 }
    it { record_17.natural_gas.should be_within(5e-3).of(0.0) }
    it { record_17.natural_gas_cost.should == 0 }
    it { record_17.propane.should be_within(5e-3).of(0.0) }
    it { record_17.propane_cost.should == 0 }
    it { record_17.fuel_oil.should be_within(5e-3).of(0.0) }
    it { record_17.fuel_oil_cost.should == 0 }
    it { record_17.kerosene.should be_within(5e-3).of(0.0) }
    it { record_17.kerosene_cost.should == 0 }
    it { record_17.wood.should be_within(5e-3).of(0.0) }
    
    let(:record_133) { recs.find 17 }
    it { record_133.weighting.should be_within(5e-2).of(15622.3) }
    it { record_133.census_region_number.should == 3 }
    it { record_133.census_division_number.should == 5 }
    it { record_133.recs_grouping_id.should == 16 }
    it { record_133.urban_rural.should == 'Rural' }
    it { record_133.metro_micro.should == 'Micro' }
    it { record_133.climate_region_id.should == 4 }
    it { record_133.climate_zone_id.should == 4 }
    it { record_133.hdd_2009.should be_within(5e-3).of(1901.67) }
    it { record_133.cdd_2009.should be_within(5e-4).of(891.111) }
    it { record_133.hdd_avg.should be_within(5e-3).of(1888.89) }
    it { record_133.cdd_avg.should be_within(5e-4).of(911.667) }
    it { record_133.building_type.should == 'Single-family Detached' }
    it { record_133.converted_house.should == nil }
    it { record_133.condo_coop.should == nil }
    it { record_133.apartments.should == nil }
    it { record_133.year_built.should == 1963 }
    it { record_133.year_occupied.should == 1965 }
    it { record_133.building_floors.should == 1 }
    it { record_133.levels.should == 1 }
    it { record_133.area.should be_within(5e-4).of(137.682) }
    it { record_133.rooms.should == 6 }
    it { record_133.bedrooms.should == 3 }
    it { record_133.bathrooms.should == 1 }
    it { record_133.half_baths.should == 0 }
    it { record_133.other_rooms.should == 3 }
    it { record_133.attic_rooms.should == nil }
    it { record_133.basement_rooms.should == nil }
    it { record_133.shaded.should == true }
    it { record_133.garage.should == nil }
    it { record_133.garage_size.should == nil }
    it { record_133.garage_heated.should == nil }
    it { record_133.garage_cooled.should == nil }
    it { record_133.pool_fuel.should == nil }
    it { record_133.hot_tub_fuel.should == nil }
    it { record_133.slab.should == false }
    it { record_133.crawlspace.should == true }
    it { record_133.basement.should == nil }
    it { record_133.wall_material.should == 'Siding (Aluminum, Vinyl, Steel)' }
    it { record_133.roof_material.should == 'Composition Shingles' }
    it { record_133.attic.should == 'Unfinished' }
    it { record_133.windows.should == 13 }
    it { record_133.window_panes.should == 1 }
    it { record_133.sliding_doors.should == 0 }
    it { record_133.insulation.should == 'Poor' }
    it { record_133.drafty.should == 'Most of the time' }
    it { record_133.high_ceiling.should == false }
    it { record_133.heater.should == nil }
    it { record_133.heater_age.should == nil }
    it { record_133.heater_fuel.should == nil }
    it { record_133.heater_shared.should == nil }
    it { record_133.heater_thermostats.should == nil }
    it { record_133.heater_portion.should == nil }
    it { record_133.heater_2.should == nil }
    it { record_133.heater_2_fuel.should == nil }
    it { record_133.heater_3.should == nil }
    it { record_133.heater_3_fuel.should == nil }
    it { record_133.heater_4.should == nil }
    it { record_133.heater_4_fuel.should == nil }
    it { record_133.heater_5.should == nil }
    it { record_133.heater_5_fuel.should == nil }
    it { record_133.heater_6.should == nil }
    it { record_133.heater_6_fuel.should == nil }
    it { record_133.heater_unused.should == nil }
    it { record_133.heater_unused_fuel.should == nil }
    it { record_133.cooler_central_age.should == nil }
    it { record_133.cooler_central_shared.should == nil }
    it { record_133.cooler_acs.should == 1 }
    it { record_133.cooler_ac_age.should == 25 }
    it { record_133.cooler_ac_energy_star.should == nil }
    it { record_133.cooler_unused.should == nil }
    it { record_133.fans.should == 0 }
    it { record_133.water_heater.should == nil }
    it { record_133.water_heater_fuel.should == nil }
    it { record_133.water_heater_size.should == nil }
    it { record_133.water_heater_age.should == nil }
    it { record_133.water_heater_shared.should == nil }
    it { record_133.water_heater_2.should == nil }
    it { record_133.water_heater_2_fuel.should == nil }
    it { record_133.water_heater_2_size.should == nil }
    it { record_133.water_heater_2_age.should == nil }
    it { record_133.storage_water_heaters.should == 0 }
    it { record_133.tankless_water_heaters.should == 0 }
    it { record_133.lights_high_use.should == 0 }
    it { record_133.lights_high_use_efficient.should == nil }
    it { record_133.lights_med_use.should == 0 }
    it { record_133.lights_med_use_efficient.should == nil }
    it { record_133.lights_low_use.should == 1 }
    it { record_133.lights_low_use_efficient.should == 1 }
    it { record_133.lights_outdoor.should == 0 }
    it { record_133.lights_outdoor_efficient.should == nil }
    it { record_133.cooking_fuel.should == nil }
    it { record_133.stoves.should == 0 }
    it { record_133.stove_fuel.should == nil }
    it { record_133.cooktops.should == 0 }
    it { record_133.cooktop_fuel.should == nil }
    it { record_133.ovens.should == 0 }
    it { record_133.oven_type.should == nil }
    it { record_133.oven_fuel.should == nil }
    it { record_133.outdoor_grill_fuel.should == nil }
    it { record_133.indoor_grill_fuel.should == nil }
    it { record_133.toaster.should == true }
    it { record_133.coffee.should == false }
    it { record_133.fridges.should == 1 }
    it { record_133.fridge_type.should == 'Half-size / compact' }
    it { record_133.fridge_size.should == 'Half-size / compact' }
    it { record_133.fridge_defrost.should == 'Manual' }
    it { record_133.fridge_door_ice.should == false }
    it { record_133.fridge_age.should == 3 }
    it { record_133.fridge_energy_star.should == true }
    it { record_133.fridge_2_type.should == nil }
    it { record_133.fridge_2_size.should == nil }
    it { record_133.fridge_2_defrost.should == nil }
    it { record_133.fridge_2_age.should == nil }
    it { record_133.fridge_2_energy_star.should == nil }
    it { record_133.fridge_3_type.should == nil }
    it { record_133.fridge_3_size.should == nil }
    it { record_133.fridge_3_defrost.should == nil }
    it { record_133.fridge_3_age.should == nil }
    it { record_133.fridge_3_energy_star.should == nil }
    it { record_133.freezers.should == nil }
    it { record_133.freezer_type.should == nil }
    it { record_133.freezer_size.should == nil }
    it { record_133.freezer_defrost.should == nil }
    it { record_133.freezer_age.should == nil }
    it { record_133.freezer_2_type.should == nil }
    it { record_133.freezer_2_size.should == nil }
    it { record_133.freezer_2_defrost.should == nil }
    it { record_133.freezer_2_age.should == nil }
    it { record_133.dishwasher_age.should == nil }
    it { record_133.dishwasher_energy_star.should == nil }
    it { record_133.washer.should == nil }
    it { record_133.washer_age.should == nil }
    it { record_133.washer_energy_star.should == nil }
    it { record_133.dryer_fuel.should == nil }
    it { record_133.dryer_age.should == nil }
    it { record_133.tvs.should == 1 }
    it { record_133.tv_size.should == '21 to 26 inches' }
    it { record_133.tv_type.should == 'CRT' }
    it { record_133.tv_theater.should == false }
    it { record_133.tv_2_size.should == nil }
    it { record_133.tv_2_type.should == nil }
    it { record_133.tv_2_theater.should == nil }
    it { record_133.tv_3_size.should == nil }
    it { record_133.tv_3_type.should == nil }
    it { record_133.tv_3_theater.should == nil }
    it { record_133.computers.should == 0 }
    it { record_133.computer_type.should == nil }
    it { record_133.computer_monitor.should == nil }
    it { record_133.computer_2_type.should == nil }
    it { record_133.computer_2_monitor.should == nil }
    it { record_133.computer_3_type.should == nil }
    it { record_133.computer_3_monitor.should == nil }
    it { record_133.internet.should == nil }
    it { record_133.printers.should == nil }
    it { record_133.fax.should == false }
    it { record_133.copier.should == false }
    it { record_133.well_pump.should == false }
    it { record_133.engine_block_heater.should == nil }
    it { record_133.aquarium.should == false }
    it { record_133.stereo.should == false }
    it { record_133.cordless_phone.should == false }
    it { record_133.answering_machine.should == false }
    it { record_133.tools.should == 0 }
    it { record_133.electronics.should == 0 }
    it { record_133.home_business.should == false }
    it { record_133.home_during_week.should == true }
    it { record_133.telecommuting.should == nil }
    it { record_133.unusual_activities.should == false }
    it { record_133.heat_area.should == 0 }
    it { record_133.heat_rooms.should == nil }
    it { record_133.heat_attic_portion.should be_within(5e-4).of(0.0) }
    it { record_133.heat_basement_portion.should == nil }
    it { record_133.heat_temp_day.should == nil }
    it { record_133.heat_temp_night.should == nil }
    it { record_133.heat_temp_away.should == nil }
    it { record_133.heat_auto_adjust_day.should == nil }
    it { record_133.heat_auto_adjust_night.should == nil }
    it { record_133.cool_area.should be_within(5e-5).of(22.9471) }
    it { record_133.cool_rooms.should == nil }
    it { record_133.cool_attic_portion.should be_within(5e-4).of(0.0) }
    it { record_133.cool_basement_portion.should == nil }
    it { record_133.cool_temp_day.should == nil }
    it { record_133.cool_temp_night.should == nil }
    it { record_133.cool_temp_away.should == nil }
    it { record_133.cool_auto_adjust_day.should == nil }
    it { record_133.cool_auto_adjust_night.should == nil }
    it { record_133.cooler_central_use.should == nil }
    it { record_133.cooler_ac_use.should == 'Turned on occasionally' }
    it { record_133.fan_use.should == nil }
    it { record_133.humidifier_use.should == nil }
    it { record_133.dehumidifier_use.should == nil }
    it { record_133.oven_use.should == nil }
    it { record_133.microwave_use.should == 'Very little' }
    it { record_133.microwave_defrost.should == false }
    it { record_133.cooking_frequency.should == 13 }
    it { record_133.fridge_2_use.should == nil }
    it { record_133.fridge_3_use.should == nil }
    it { record_133.dishwasher_use.should == nil }
    it { record_133.washer_use.should == nil }
    it { record_133.washer_temp_wash.should == nil }
    it { record_133.washer_temp_rinse.should == nil }
    it { record_133.dryer_use.should == nil }
    it { record_133.tv_weekday_use.should == 1 }
    it { record_133.tv_weekend_use.should == 1 }
    it { record_133.tv_2_weekday_use.should == nil }
    it { record_133.tv_2_weekend_use.should == nil }
    it { record_133.tv_3_weekday_use.should == nil }
    it { record_133.tv_3_weekend_use.should == nil }
    it { record_133.computer_use.should == nil }
    it { record_133.computer_idle.should == nil }
    it { record_133.computer_2_use.should == nil }
    it { record_133.computer_2_idle.should == nil }
    it { record_133.computer_3_use.should == nil }
    it { record_133.computer_3_idle.should == nil }
    it { record_133.tool_charging.should == nil }
    it { record_133.tool_vampires.should == nil }
    it { record_133.electronic_charging.should == nil }
    it { record_133.electronic_vampires.should == nil }
    it { record_133.energy_audit.should == false }
    it { record_133.energy_audit_year.should == nil }
    it { record_133.energy_audit_incent.should == nil }
    it { record_133.energy_audit_incent_year.should == nil }
    it { record_133.insulation_added.should == false }
    it { record_133.insulation_added_year.should == nil }
    it { record_133.insulation_incent.should == nil }
    it { record_133.insulation_incent_year.should == nil }
    it { record_133.windows_replaced.should == 'None' }
    it { record_133.windows_incent.should == nil }
    it { record_133.windows_incent_year.should == nil }
    it { record_133.caulking_added.should == false }
    it { record_133.caulking_added_year.should == nil }
    it { record_133.caulking_incent.should == nil }
    it { record_133.caulking_incent_year.should == nil }
    it { record_133.heater_maintained.should == nil }
    it { record_133.heater_replaced.should == nil }
    it { record_133.heater_incent.should == nil }
    it { record_133.heater_incent_year.should == nil }
    it { record_133.cooler_central_maintained.should == nil }
    it { record_133.cooler_central_replaced.should == nil }
    it { record_133.cooler_central_incent.should == nil }
    it { record_133.cooler_central_incent_year.should == nil }
    it { record_133.cooler_ac_replaced.should == nil }
    it { record_133.cooler_ac_incent.should == nil }
    it { record_133.cooler_ac_incent_year.should == nil }
    it { record_133.water_heater_blanket.should == nil }
    it { record_133.water_heater_incent.should == nil }
    it { record_133.water_heater_incent_year.should == nil }
    it { record_133.lights_replaced.should == true }
    it { record_133.lights_incent.should == 'None' }
    it { record_133.lights_incent_year.should == nil }
    it { record_133.dishwasher_replaced.should == nil }
    it { record_133.dishwasher_incent.should == nil }
    it { record_133.dishwasher_incent_year.should == nil }
    it { record_133.fridge_replaced.should == true }
    it { record_133.fridge_incent.should == 'None' }
    it { record_133.fridge_incent_year.should == nil }
    it { record_133.freezer_replaced.should == nil }
    it { record_133.freezer_incent.should == nil }
    it { record_133.freezer_incent_year.should == nil }
    it { record_133.washer_replaced.should == nil }
    it { record_133.washer_incent.should == nil }
    it { record_133.washer_incent_year.should == nil }
    it { record_133.renewable_energy.should == nil }
    it { record_133.own_rent.should == 'Owner' }
    it { record_133.sex.should == 'Male' }
    it { record_133.employment.should == 'Not employed / retired' }
    it { record_133.live_with_spouse.should == false }
    it { record_133.race.should == 'Black / African American' }
    it { record_133.latino.should == false }
    it { record_133.education.should == 'Kindergarten to grade 12' }
    it { record_133.household_size.should == 1 }
    it { record_133.member_1_age.should == 46 }
    it { record_133.member_2_age.should == nil }
    it { record_133.member_3_age.should == nil }
    it { record_133.member_4_age.should == nil }
    it { record_133.member_5_age.should == nil }
    it { record_133.member_6_age.should == nil }
    it { record_133.member_7_age.should == nil }
    it { record_133.member_8_age.should == nil }
    it { record_133.member_9_age.should == nil }
    it { record_133.member_10_age.should == nil }
    it { record_133.member_11_age.should == nil }
    it { record_133.member_12_age.should == nil }
    it { record_133.member_13_age.should == nil }
    it { record_133.member_14_age.should == nil }
    it { record_133.income.should == 1250 }
    it { record_133.income_employment.should == false }
    it { record_133.income_retirement.should == false }
    it { record_133.income_ssi.should == false }
    it { record_133.income_welfare.should == false }
    it { record_133.income_investment.should == false }
    it { record_133.income_other.should == false }
    it { record_133.poverty_100.should == true }
    it { record_133.poverty_150.should == true }
    it { record_133.public_housing_authority.should == nil }
    it { record_133.low_rent.should == nil }
    it { record_133.food_stamps.should == true }
    it { record_133.pays_electricity_heat.should == nil }
    it { record_133.pays_electricity_water.should == nil }
    it { record_133.pays_electricity_cooking.should == nil }
    it { record_133.pays_electricity_cool.should == nil }
    it { record_133.pays_electricity_lighting.should == 'Paid by the household' }
    it { record_133.pays_natural_gas_heat.should == nil }
    it { record_133.pays_natural_gas_water.should == nil }
    it { record_133.pays_natural_gas_cooking.should == nil }
    it { record_133.pays_natural_gas_other.should == nil }
    it { record_133.pays_fuel_oil.should == nil }
    it { record_133.pays_propane.should == nil }
    it { record_133.electricity_heat.should == false }
    it { record_133.electricity_heat_2.should == false }
    it { record_133.electricity_cool.should == true }
    it { record_133.electricity_water.should == false }
    it { record_133.electricity_cooking.should == false }
    it { record_133.electricity_other.should == true }
    it { record_133.natural_gas_heat.should == false }
    it { record_133.natural_gas_heat_2.should == false }
    it { record_133.natural_gas_water.should == false }
    it { record_133.natural_gas_cooking.should == false }
    it { record_133.natural_gas_other.should == false }
    it { record_133.propane_heat.should == false }
    it { record_133.propane_heat_2.should == false }
    it { record_133.propane_water.should == false }
    it { record_133.propane_cooking.should == false }
    it { record_133.propane_other.should == false }
    it { record_133.fuel_oil_heat.should == false }
    it { record_133.fuel_oil_heat_2.should == false }
    it { record_133.fuel_oil_water.should == false }
    it { record_133.fuel_oil_other.should == false }
    it { record_133.kerosene_heat.should == false }
    it { record_133.kerosene_heat_2.should == false }
    it { record_133.kerosene_water.should == false }
    it { record_133.kerosene_other.should == false }
    it { record_133.wood_heat.should == false }
    it { record_133.wood_heat_2.should == false }
    it { record_133.wood_water.should == false }
    it { record_133.wood_other.should == false }
    it { record_133.solar_heat.should == false }
    it { record_133.solar_heat_2.should == false }
    it { record_133.solar_water.should == false }
    it { record_133.solar_other.should == false }
    it { record_133.other_heat.should == false }
    it { record_133.other_heat_2.should == false }
    it { record_133.other_water.should == false }
    it { record_133.other_cooking.should == false }
    it { record_133.energy.should be_within(5e-3).of(7484.57) }
    it { record_133.energy_cost.should == 271 }
    it { record_133.electricity.should be_within(5e-3).of(2079) }
    it { record_133.electricity_cost.should == 271 }
    it { record_133.natural_gas.should be_within(5e-3).of(0.0) }
    it { record_133.natural_gas_cost.should == 0 }
    it { record_133.propane.should be_within(5e-3).of(0.0) }
    it { record_133.propane_cost.should == 0 }
    it { record_133.fuel_oil.should be_within(5e-3).of(0.0) }
    it { record_133.fuel_oil_cost.should == 0 }
    it { record_133.kerosene.should be_within(5e-3).of(0.0) }
    it { record_133.kerosene_cost.should == 0 }
    it { record_133.wood.should be_within(5e-3).of(0.0) }
  end
end
