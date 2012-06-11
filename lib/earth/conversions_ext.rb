require 'conversions'

# Distance: base unit = kilometre
Conversions.register :kilometres, :miles,          0.621371192
Conversions.register :kilometres, :nautical_miles, 0.539956803
Conversions.register :kilometres, :billion_miles,  1.kilometres.to(:miles) / 1_000_000_000 # for AutomobileTypeFuelYear

# Area
Conversions.register :square_metres, :square_feet,         10.7639104
Conversions.register :square_metres, :million_square_feet, (1.square_metres.to(:square_feet) / 1_000_000)

# Volume, liquid: base unit = litre
Conversions.register :gallons,      :litres, 3.78541178
Conversions.register :cubic_inches, :litres, 0.016387064
Conversions.register :barrels,      :litres, 42.gallons.to(:litres)

# Volume, solid: base unit = cubic metre
Conversions.register :cubic_metres, :cubic_feet,         35.3146667
Conversions.register :cubic_metres, :hundred_cubic_feet, (1.cubic_metres.to(:cubic_feet) / 100)
Conversions.register :cubic_metres, :billion_cubic_feet, (1.cubic_metres.to(:cubic_feet) / 1_000_000_000)

# Mass: base unit = kilogram
Conversions.register :kilograms, :grams,         1_000.0
Conversions.register :kilograms, :metric_tonnes, 0.001
Conversions.register :kilograms, :pounds,        2.20462262
Conversions.register :kilograms, :tons,          0.00110231131

# Energy: base unit = megajoule
Conversions.register :btus,                   :megajoules, 0.00105505585
Conversions.register :kbtus,                  :megajoules, 1_000.btus.to(:megajoules)
Conversions.register :trillion_btus,          :megajoules, 1_000_000_000_000.btus.to(:megajoules)
Conversions.register :kilowatt_hours,         :megajoules, 3.6
Conversions.register :billion_kilowatt_hours, :megajoules, 1_000_000_000.kilowatt_hours.to(:megajoules)

# Electricity: base unit = kilowatt hour
Conversions.register :kilowatt_hours, :billion_kilowatt_hours, (1.0 / 1_000_000_000.0)

# Monetary
Conversions.register :dollars, :cents, 100.0

# GHG
Conversions.register :carbon, :co2, (44.0 / 12.0)

# Temperature
Conversions.register :degrees_celsius, :degrees_fahrenheit, (9.0 / 5.0) # NOTE: only for conversion between degrees NOT temperatures: 1 degree C = 9/5 degrees F but a temperature of 1 degree C = temperature of 33.8 degrees F

# Complex
Conversions.register :kilometres_per_litre,                 :miles_per_gallon,                        (1.kilometres.to(:miles) / 1.litres.to(:gallons))
Conversions.register :litres_per_kilometre,                 :gallons_per_mile,                        (1.litres.to(:gallons) / 1.kilometres.to(:miles))
Conversions.register :kilograms_per_square_metre,           :pounds_per_square_foot,                  (1.kilograms.to(:pounds) / 1.square_metres.to(:square_feet))
Conversions.register :litres_per_square_metre_hour,         :gallons_per_square_foot_hour,            (1.litres.to(:gallons) / 1.square_metres.to(:square_feet))
Conversions.register :litres_per_room_night,                :gallons_per_room_night,                  (1.litres.to(:gallons))
Conversions.register :cubic_metres_per_square_metre_hour,   :hundred_cubic_feet_per_square_foot_hour, (1.cubic_metres.to(:hundred_cubic_feet) / 1.square_metres.to(:square_feet))
Conversions.register :cubic_metres_per_room_night,          :hundred_cubic_feet_per_room_night,       (1.cubic_metres.to(:hundred_cubic_feet))
Conversions.register :kilowatt_hours_per_square_metre,      :kilowatt_hours_per_square_foot,          (1 / 1.square_metres.to(:square_feet))
Conversions.register :kilowatt_hours_per_square_metre_hour, :kilowatt_hours_per_square_foot_hour,     (1 / 1.square_metres.to(:square_feet))
Conversions.register :megajoules_per_square_metre_hour,     :kbtus_per_square_foot_hour,              (1.megajoules.to(:kbtus) / 1.square_metres.to(:square_feet))
Conversions.register :megajoules_per_room_night,            :kbtus_per_room_night,                    (1.megajoules.to(:kbtus))
Conversions.register :million_btu_per_barrel,               :megajoules_per_litre,                    (1_000_000.btus.to(:megajoules) / 1.barrels.to(:litres)) # Fuel
Conversions.register :btus_per_cubic_foot,                  :megajoules_per_cubic_metre,              (1.btus.to(:megajoules) / 1.cubic_feet.to(:cubic_metres)) # Fuel
Conversions.register :teragrams_per_quadrillion_btu,        :grams_per_megajoule,                     (1_000_000_000_000 / 1_000_000_000_000_000.btus.to(:megajoules)) # Fuel

# Odd units for EPA fuel economy guide
# Conversions.register :epa_gallon_gasoline_equivalents,          :kilowatt_hours,                        33.705
# Conversions.register :epa_gallon_gasoline_equivalents,          :cubic_metres_compressed_natural_gas,    3.587
# Conversions.register :epa_gallon_gasoline_equivalents,          :kilograms_hydrogen,                     1.012
# Conversions.register :epa_miles_per_gallon_gasoline_equivalent, :kilometres_per_litre,                  (1.miles_per_gallon.to(:kilometres_per_litre))
# Conversions.register :epa_miles_per_gallon_gasoline_equivalent, :kilowatt_hours_per_hundred_kilometres, (1 / (1.kilowatt_hours.to(:epa_gallon_gasoline_equivalents) / 100.kilometres.to(:miles)))
# Conversions.register :epa_miles_per_gallon_gasoline_equivalent, :cubic_metres_per_hundred_kilometres,   (1 / (1.cubic_metres_compressed_natural_gas.to(:epa_gallon_gasoline_equivalents) / 100.kilometres.to(:miles)))
# Conversions.register :epa_miles_per_gallon_gasoline_equivalent, :kilograms_per_hundred_kilometres,      (1 / (1.kilograms_hydrogen.to(:epa_gallon_gasoline_equivalents) / 100.kilometres.to(:miles)))

# Odd units for EPA automobile data
Conversions.register :grams_per_mile,  :kilograms_per_kilometre, 1.grams.to(:kilograms) / 1.miles.to(:kilometres)
Conversions.register :teragrams_co2e,  :kilograms_co2e,          1_000_000_000.0
Conversions.register :million_gallons, :litres,                  1_000_000.gallons.to(:litres)

# Odd units for pet - FIXME use megajoules rather than joules
Conversions.register :kilocalories,           :joules,              4_184.0
Conversions.register :kilocalories_per_pound, :joules_per_kilogram, (1.kilocalories.to(:joules) / 1.pounds.to(:kilograms))
Conversions.register :grams_per_kilocalorie,  :kilograms_per_joule, (1.grams.to(:kilograms) / 1.kilocalories.to(:joules))


# Odd units for residence - FIXME use megajoules rather than joules
Conversions.register :cords,          :joules,             2.11011171e10
Conversions.register :therms,         :joules,             105_505_585.0 # should only be used for RECS 2005
Conversions.register :joules,         :litres_of_fuel_oil, (1.0 / (138_690.0 * 3.78541178 * 1_055.05585)) # should only be used for RECS 2005
Conversions.register :joules,         :litres_of_propane,  (1.0 / (91_333.0 * 3.78541178 * 1_055.05585)) # should only be used for RECS 2005
Conversions.register :joules,         :litres_of_kerosene, (1.0 / (135_000.0 * 3.78541178 * 1_055.05585)) # should only be used for RECS 2005
Conversions.register :joules,         :kilograms_of_coal,  (1.0 / (22_342_000.0 * 0.00110231131 * 1_055.05585)) # should only be used for RECS 2005
Conversions.register :kbtus,          :joules,             (1_000.0 * 1_055.05585)
Conversions.register :watt_hours,     :joules,             3_600.0
Conversions.register :kilowatt_hours, :joules,             3_600_000.0

# Odd units for CBECS 2003
Conversions.register :trillion_btus_per_million_square_feet, :megajoules_per_square_metre,     (1.trillion_btus.to(:megajoules) / 1.square_feet.to(:square_metres))
Conversions.register :kilowatt_hours_per_square_foot, :megajoules_per_square_metre,            (1.kilowatt_hours.to(:megajoules) / 1.square_feet.to(:square_metres))
Conversions.register :billion_cubic_feet_of_natural_gas, :megajoules,                          (1_000_000_000.cubic_feet.to(:cubic_metres) * 38.3395) # 2003 NatGas energy content MJ/m3
Conversions.register :cubic_feet_of_natural_gas_per_square_foot, :megajoules_per_square_metre, ((1.cubic_feet.to(:cubic_metres) * 38.3395) / 1.square_feet.to(:square_metres))
Conversions.register :million_gallons_of_fuel_oil, :megajoules,                                (1_000_000.gallons.to(:litres) * 41.9203) # Residual Fuel Oil No. 6 energy content MJ/l from Fuels
Conversions.register :gallons_of_fuel_oil_per_square_foot, :megajoules_per_square_metre,       ((41.9203 * 1.gallons.to(:litres)) / 1.square_feet.to(:square_metres))

# Only used in app1
Conversions.register(:pounds_per_gallon, :kilograms_per_litre, 0.119826427) # only used in app1
Conversions.register(:pounds_per_mile, :kilograms_per_kilometre, 0.281849232)


# DEPRECATE as of 1/20/2012 don't think these are used anywhere
Conversions.register(:kilowatt_hours, :watt_hours, 1_000.0)
Conversions.register(:kilowatt_hours, :btus, 3_412.14163)
Conversions.register(:watt_hours, :btus, 3.4121414799)
Conversions.register(:kbtus, :btus, 1_000.0)
Conversions.register(:btus, :joules, 1_055.05585)
Conversions.register(:btus, :megajoules, 0.00105505585)
Conversions.register(:kilograms, :lbs, 2.20462262)
Conversions.register(:kilograms_per_kilowatt_hour, :kilograms_per_megawatt_hour, 1_000.0)
