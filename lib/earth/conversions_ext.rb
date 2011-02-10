require 'conversions'
Conversions.register(:miles, :nautical_miles, 0.868976242)
Conversions.register(:kilometres, :nautical_miles, 0.539956803)
Conversions.register(:pounds_per_gallon, :kilograms_per_litre, 0.119826427)
Conversions.register(:inches, :meters, 0.0254)
Conversions.register(:kilowatt_hours, :watt_hours, 1_000.0)
Conversions.register(:kilowatt_hours, :btus, 3_412.14163) # obsolete?
Conversions.register(:watt_hours, :btus, 3.4121414799) # obsolete?
Conversions.register(:watt_hours, :joules, 3_600.0)
Conversions.register(:kilowatt_hours, :joules, 3_600_000.0)

# Conversions.register(:btus, :gallons_of_kerosene, 0.000007419521097)
Conversions.register(:joules, :litres_of_kerosene, 1.0 / (135_000.0 * 3.78541178 * 1_055.05585)) # should only be used for RECS 2005

# Conversions.register(:btus, :gallons_of_propane, 0.000010471204188)
Conversions.register(:joules, :litres_of_propane, 1.0 / (91_333.0 * 3.78541178 * 1_055.05585)) # should only be used for RECS 2005

# Conversions.register(:btus, :therms, 0.000010002388121)
Conversions.register(:therms, :joules, 105_505_585.0) # should only be used for RECS 2005

# Conversions.register(:btus, :gallons_of_fuel_oil, 0.0000072007637183)
Conversions.register(:joules, :litres_of_fuel_oil, 1.0 / (138_690.0 * 3.78541178 * 1_055.05585)) # should only be used for RECS 2005

# Conversions.register(:tons_of_coal, :btus, 20_169_000.0)
Conversions.register(:joules, :kilograms_of_coal, 1.0 / (22_342_000.0 * 0.00110231131 * 1_055.05585)) # should only be used for RECS 2005

Conversions.register(:kilograms, :lbs, 2.20462262)
Conversions.register(:kbtus, :btus, 1_000.0)
Conversions.register(:square_feet, :square_metres, 0.09290304)
Conversions.register(:pounds_per_square_foot, :kilograms_per_square_metre, 4.88242764)
Conversions.register(:kilograms_per_kilowatt_hour, :kilograms_per_megawatt_hour, 1_000.0)
Conversions.register(:btus, :joules, 1_055.05585)
Conversions.register(:btus, :megajoules, 0.00105505585)
Conversions.register(:kbtus, :joules, 1_000.0 * 1_055.05585)
Conversions.register(:kbtus, :megajoules, 1.05505585)
Conversions.register(:cords, :joules, 2.11011171e10)

Conversions.register(:gallons_per_mile, :litres_per_kilometre, 2.35214583)
Conversions.register(:pounds_per_mile, :kilograms_per_kilometre, 0.281849232)
Conversions.register(:dollars, :cents, 100)
Conversions.register(:cubic_feet, :cubic_metres, 0.0283168466)
# 1 (kilocalories per pound) = 9 224.14105 joules per kilogram
Conversions.register :kilocalories_per_pound, :joules_per_kilogram, 9_224.14105
# 1 (grams per kilocalories) = 2.39005736 × 10-7 kilograms per joules
Conversions.register :grams_per_kilocalorie, :kilograms_per_joule, 2.39005736e-7
# 1 joule = 0.000239005736 kilocalories
Conversions.register :joules, :kilocalories, 0.000239005736

Conversions.register :carbon, :co2, (44.0 / 12.0)
