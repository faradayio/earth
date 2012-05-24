require 'alchemist'

Alchemist.register :area, :million_square_feet, 1_000_000.square_feet.to.square_metres

Alchemist.register :volume, [:cubic_inch, :cubic_inches], 0.016387064.litres
Alchemist.register :volume, [:cubic_metre, :cubic_metres], 1.cubic_meter
Alchemist.register :volume, [:cubic_foot, :cubic_feet], 0.0283168466.cubic_metres
Alchemist.register :volume, :hundred_cubic_feet, 100.cubic_feet
Alchemist.register :volume, :billion_cubic_feet, 1_000_000_000.cubic_feet

Alchemist.register :mass, [:metric_tonne, :metric_tonnes], 1.metric_ton

Alchemist.register :energy, [:btu, :btus], 1.british_thermal_unit
Alchemist.register :energy, [:kbtu, :kbtus], 1000.btu
Alchemist.register :energy, :trillion_btus, 1_000_000_000_000.btus
Alchemist.register :energy, :billion_kilowatt_hours, 1_000_000_000.kilowatt_hours
# Odd units for residence
Alchemist.register :energy, [:cord, :cords], 2.11011171e10
Alchemist.register :energy, :litres_of_fuel_oil, (138_690.0 * 3.78541178 * 1_055.05585) # should only be used for RECS 2005
Alchemist.register :energy, :litres_of_propane,  (91_333.0 * 3.78541178 * 1_055.05585) # should only be used for RECS 2005
Alchemist.register :energy, :litres_of_kerosene, (135_000.0 * 3.78541178 * 1_055.05585) # should only be used for RECS 2005
Alchemist.register :energy, :kilograms_of_coal,  (22_342_000.0 * 0.00110231131 * 1_055.05585) # should only be used for RECS 2005
# Odd units for CBECS 2003
Alchemist.register :energy, [:cubic_foot_of_natural_gas, :cubic_feet_of_natural_gas], (1.cubic_foot.to.cubic_metres.to_f * 38.3395.megajoules.to.joules.to_f) # 2003 NatGas energy content MJ/m3
Alchemist.register :energy, :billion_cubic_feet_of_natural_gas, 1_000_000_000.cubic_feet_of_natural_gas.to.joules
Alchemist.register :energy, [:gallon_of_fuel_oil, :gallons_of_fuel_oil], 1.gallons.to.litres.to_f * 41.9203.megajoules.to.joules.to_f # Residual Fuel Oil No. 6 energy content MJ/l from Fuels
Alchemist.register :energy, :million_gallons_of_fuel_oil, 1_000_000.gallons_of_fuel_oil.to.joules

Alchemist.register :currency, [:dollar, :dollars], 1.0 # the almighty dollar
Alchemist.register :currency, :cents, 0.01.dollars

Alchemist.register :mass, [:amu, :u], 1.660538921e-27.kilograms.to_f
Alchemist.register :mass, :carbon, 12.0.u
Alchemist.register :mass, :co2, 44.0.u

# Complex
Alchemist.register :fuel_economy, :kilometres_per_litre, 1.0
Alchemist.register :fuel_economy, :miles_per_gallon, (1.mile.to.kilometers.to_f / 1.gallon.to.litres.to_f)

Alchemist.register :reverse_fuel_economy, :litres_per_kilometre, 1.0
Alchemist.register :reverse_fuel_economy, :gallons_per_mile, (1.gallon.to.litres.to_f / 1.mile.to.kilometers.to_f)

Alchemist.register :mass_area_intensity, :kilograms_per_square_metre, 1.0
Alchemist.register :mass_area_intensity, :pounds_per_square_foot, (1.pound.to.kilograms.to_f / 1.square_foot.to.square_metres.to_f)

Alchemist.register :energy_area_intensity, :joules_per_square_metre, 1.0
Alchemist.register :energy_area_intensity, :megajoules_per_square_metre, 1.megajoule.to.joules.to_f
Alchemist.register :energy_area_intensity, :kilowatt_hours_per_square_metre, 1.kilowatt_hour.to.joules.to_f
Alchemist.register :energy_area_intensity, :kilowatt_hours_per_square_foot, 1.kilowatt_hour.to.joules.to_f / 1.square_foot.to.square_metres.to_f
# Odd units for CBECS 2003
Alchemist.register :energy_area_intensity, :trillion_btus_per_million_square_feet, 1.trillion_btus.to.joules.to_f / 1_000_000.square_feet.to.square_metres.to_f
Alchemist.register :energy_area_intensity, :cubic_feet_of_natural_gas_per_square_foot, 1.cubic_foot_of_natural_gas.to.joules.to_f / 1.square_foot.to.square_metres.to_f
Alchemist.register :energy_area_intensity, :gallons_of_fuel_oil_per_square_foot, 1.gallon_of_fuel_oil.to.joules.to_f / 1.square_foot.to.square_metres.to_f

Alchemist.register :hourly_energy_area_intensity, :megajoules_per_square_metre_hour, 1.0
Alchemist.register :hourly_energy_area_intensity, :kilowatt_hours_per_square_metre_hour, 1.kilowatt_hour.to.megajoules.to_f
Alchemist.register :hourly_energy_area_intensity, :kilowatt_hours_per_square_foot_hour, 1.kilowatt_hour.to.megajoules.to_f / 1.square_foot.to.square_metres.to_f
Alchemist.register :hourly_energy_area_intensity, :kbtus_per_square_foot_hour, 1.kbtu.to.megajoules.to_f / 1.square_foot.to_f

Alchemist.register :hourly_area_volumetric_intensity, :litres_per_square_metre_hour, 1.0
Alchemist.register :hourly_area_volumetric_intensity, :gallons_per_square_foot_hour, (1.gallon.to.litres.to_f / 1.square_foot.to.square_metres.to_f)
Alchemist.register :hourly_area_volumetric_intensity, :cubic_metres_per_square_metre_hour, 1_000.0
Alchemist.register :hourly_area_volumetric_intensity, :hundred_cubic_feet_per_square_foot_hour, (1.hundred_cubic_feet.to.cubic_meters.to_f / 1.square_feet.to.square_meters.to_f)

Alchemist.register :nightly_volumetric_intensity, :litres_per_room_night, 1.0
Alchemist.register :nightly_volumetric_intensity, :gallons_per_room_night, 1.gallon.to.litres.to_f
Alchemist.register :nightly_volumetric_intensity, :cubic_metres_per_room_night, 1_000.0
Alchemist.register :nightly_volumetric_intensity, :hundred_cubic_feet_per_room_night, 1.hundred_cubic_feet.to.litres.to_f

Alchemist.register :nightly_energy_intensity, :megajoules_per_room_night, 1.0
Alchemist.register :nightly_energy_intensity, :kbtus_per_room_night, 1.kbtus.to.megajoules.to_f

Alchemist.register :volumetric_energy_content, :megajoules_per_litre, 1.0
Alchemist.register :volumetric_energy_content, :megajoules_per_cubic_metre, 1_000.0
Alchemist.register :volumetric_energy_content, :million_btu_per_barrel, 1_000_000.btus.to.megajoules.to_f / 1.barrel.to.litres.to_f
Alchemist.register :volumetric_energy_content, :btus_per_cubic_foot, 1.btus.to.megajoules.to_f / 1.cubic_feet.to.litres.to_f # Fuel

Alchemist.register :energetic_mass, :grams_per_joule, 1.0
Alchemist.register :energetic_mass, :grams_per_megajoule, 1.0 / 1.megajoule.to.joules.to_f
Alchemist.register :energetic_mass, :teragrams_per_quadrillion_btu, 1_000_000_000_000 / 1_000_000_000_000_000.btus.to.joules.to_f # Fuel
# Odd units for pet
Alchemist.register :energetic_mass, :grams_per_kilocalorie, 1.0 / 1.kilocalorie.to.joules.to_f
Alchemist.register :energetic_mass, :kilograms_per_joule, 1.kilogram.to.grams.to_f

# Odd units for pet
Alchemist.register :energy_content, :joules_per_gram, 1.0
Alchemist.register :energy_content, :joules_per_kilogram, 1.0 / 1.kilogram.to.grams.to_f
Alchemist.register :energy_content, :kilocalories_per_pound, 1.kilocalories.to.joules.to_f / 1.pounds.to.grams.to_f
