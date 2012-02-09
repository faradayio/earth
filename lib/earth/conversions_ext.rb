require 'conversions'

# Distance: base unit = kilometre
Conversions.register :kilometres, :miles,          0.621371192
Conversions.register :kilometres, :nautical_miles, 0.539956803

# Area
Conversions.register :square_metres, :square_feet,         10.7639104
Conversions.register :square_metres, :million_square_feet, (1.square_metres.to(:square_feet) / 1_000_000)

# Volume, liquid: base unit = litre
Conversions.register :litres, :gallons,      0.264172052
Conversions.register :litres, :cubic_inches, 61.0237441

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
Conversions.register :megajoules, :btus,           947.81712
Conversions.register :megajoules, :kbtus,          (1.megajoules.to(:btus) / 1_000)
Conversions.register :megajoules, :trillion_btus,  (1.megajoules.to(:btus) / 1_000_000_000_000)
Conversions.register :megajoules, :kilowatt_hours, 0.277777778

# Electricity: base unit = kilowatt hour
Conversions.register :kilowatt_hours, :billion_kwh, (1.0 / 1_000_000_000.0)

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
