# For parsing the EIA RECS 2009 microdata file
require 'earth/residence/recs_2009_response'

class Recs2009Response::Parser
  AGE = {
    '1'  => 1,  # Less than 2
    '2'  => 3,  # 2 to 4
    '3'  => 7,  # 5 to 9
    '41' => 12, # 10 to 14
    '42' => 17, # 15 to 19
    '5'  => 25  # 20 or older
  }
  BOOLEAN = {
    '0' => false,
    '1' => true
  }
  BUILDING_TYPE = {
    '1' => 'Mobile Home',
    '2' => 'Single-family Detached',
    '3' => 'Single-family Attached',
    '4' => 'Apartment <4 units',
    '5' => 'Apartment >5 units'
  }
  CHARGING = {
    '1' => 'Always charging',
    '2' => 'Recharge as needed',
    '3' => 'Both'
  }
  COMPUTER_MONITOR = {
    '1' => 'CRT',
    '2' => 'LCD'
  }
  COMPUTER_TYPE = {
    '1' => 'Desktop',
    '2' => 'Laptop'
  }
  CONDO_COOP = {
    '1' => 'Condo',
    '2' => 'Coop'
  }
  CONVERTED_HOUSE = {
    '1' => true, # house converted to apt bldg that looks like a house
    '2' => false # house converted to apt bldg that looks like apt bldg
  }
  COOLER = {
    '1' => 'Central',
    '2' => 'Window/wall units',
    '3' => 'Central and window/wall units'
  }
  COOLER_USE = {
    '1' => 'Turned on occasionally',
    '2' => 'Turned on quite a bit',
    '3' => 'Turned on just about all summer'
    # '4' => 'Not used at all'
  }
  DEFROST = {
    '1' => 'Manual',
    '2' => 'Frost-free'
  }
  DEVICES = {
    '0' => 0,
    '1' => 2, # 1 to 3
    '2' => 6, # 4 to 8
    '3' => 12 # more than 8
  }
  DRAFTY = {
    '1' => 'All the time',
    '2' => 'Most of the time',
    '3' => 'Some of the time',
    '4' => 'Never'
  }
  DRYER_USE = {
    '1' => 'Every load of laundry',
    '2' => 'Some loads of laundry',
    '3' => 'Infrequent'
  }
  EDUCATION = {
    '0' => 'No schooling completed',
    '1' => 'Kindergarten to grade 12',
    '2' => 'High school diploma or GED',
    '3' => 'Some college, no degree',
    '4' => "Associate's degree",
    '5' => "Bachelor's degree",
    '6' => "Master's degree",
    '7' => 'Professional degree',
    '8' => 'Doctorate degree'
  }
  EMPLOYMENT = {
    '0' => 'Not employed / retired',
    '1' => 'Full-time',
    '2' => 'Part-time'
  }
  FINISHED_SPACE = {
    '0' => 'Unfinished',
    '1' => 'Finished'
  }
  FREEZER_SIZE = {
    '1' => 'Small (14 cu ft or less)',
    '2' => 'Medium (15 to 18 cu ft)',
    '3' => 'Large (19 to 22 cu ft)',
    '4' => 'Very large (more than 20 cu ft)'
  }
  FREEZER_TYPE = {
    '1' => 'Upright',
    '2' => 'Chest'
  }
  FRIDGE_SIZE = {
    '1' => 'Half-size / compact',
    '2' => 'Small (14 cu ft or less)',
    '3' => 'Medium (15 to 18 cu ft)',
    '4' => 'Large (19 to 22 cu ft)',
    '5' => 'Very large (more than 20 cu ft)'
  }
  FRIDGE_TYPE = {
    '1'  => 'Full-size, 1 door',
    '3'  => 'Half-size / compact',
    '4'  => 'Other',
    '5'  => 'Full-size, 3+ doors',
    '21' => 'Full-size, 2 doors, freezer beside',
    '22' => 'Full-size, 2 doors, freezer above',
    '23' => 'Full-size, 2 doors, freezer below'
  }
  FUEL = {
    '1'  => 'Natural Gas',
    '2'  => 'Propane/LPG',
    '3'  => 'Fuel Oil',
    '4'  => 'Kerosene',
    '5'  => 'Electricity',
    '7'  => 'Wood',
    '8'  => 'Solar',
    '9'  => 'District Steam',
    '21' => 'Other'
  }
  GARAGE_SIZE = {
    '1' => 'One-car',
    '2' => 'Two-car',
    '3' => 'Three-car+',
    '4' => 'Carport'
  }
  HEATER = {
    '2'  => 'Steam or Hot Water System',
    '3'  => 'Central Warm-Air Furnace',
    '4'  => 'Heat Pump',
    '5'  => 'Built-In Electric Units',
    '6'  => 'Floor or Wall Pipeless Furnace',
    '7'  => 'Built-In Room Heaters',
    '8'  => 'Heating Stove',
    '9'  => 'Fireplace',
    '10' => 'Portable Heaters', # Electric
    '11' => 'Portable Heaters', # Kerosene
    '12' => 'Cooking Stove',
    '21' => 'Other'
  }
  HEATER_PORTION = {
    '1' => 1,    # main heater provides almost all space heat
    '2' => 0.75, # main heater provides about 3/4 of space heat
    '3' => 0.5   # main heater provides closer to 1/2 of space heat
  }
  INCENTIVE = {
    '0'  => 'None',
    '1'  => 'Manfacturer or retailer rebate',
    '2'  => 'Utility or energy supplier rebate',
    '3'  => 'Tax credit',
    '4'  => 'Subsidized loan',
    '5'  => 'Weatherization assistance',
    '-8' => 'Refuse',
    '-9' => "Don't Know"
  }
  INCOME = {
    '1'  =>   1250, # Less than $2,500
    '2'  =>   3750, # $2,500 to $4,999
    '3'  =>   6250, # $5,000 to $7,499
    '4'  =>   8750, # $7,500 to $9,999
    '5'  =>  12500, # $10,000 to $14,999
    '6'  =>  17500, # $15,000 to $19,999
    '7'  =>  22500, # $20,000 to $24,999
    '8'  =>  27500, # $25,000 to $29,999
    '9'  =>  32500, # $30,000 to $34,999
    '10' =>  37500, # $35,000 to $39,999
    '11' =>  42500, # $40,000 to $44,999
    '12' =>  47500, # $45,000 to $49,999
    '13' =>  52500, # $50,000 to $54,999
    '14' =>  57500, # $55,000 to $59,999
    '15' =>  62500, # $60,000 to $64,999
    '16' =>  67500, # $65,000 to $69,999
    '17' =>  72500, # $70,000 to $74,999
    '18' =>  77500, # $75,000 to $79,999
    '19' =>  82500, # $80,000 to $84,999
    '20' =>  87500, # $85,000 to $89,999
    '21' =>  92500, # $90,000 to $94,999
    '22' =>  97500, # $95,000 to $99,999
    '23' => 110000, # $100,000 to $119,999
    '24' => 200000  # $120,000 or More
  }
  INSULATION = {
    '1' => 'Good',
    '2' => 'Adequate',
    '3' => 'Poor',
    '4' => 'None'
  }
  MEMBER_AGE = {
    '1'  => 3, # < 5 years old
    '2'  => 7, # 5-9 years old
    '3'  => 12, # 10-14 years old
    '4'  => 17, # 15-19 years old
    '5'  => 22, # 20-24 years old
    '6'  => 27, # 25-29 years old
    '7'  => 32, # 30-34 years old
    '8'  => 37, # 35-39 years old
    '9'  => 42, # 40-44 years old
    '10' => 47, # 45-49 years old
    '11' => 52, # 50-54 years old
    '12' => 57, # 55-59 years old
    '13' => 62, # 60-64 years old
    '14' => 67, # 65-69 years old
    '15' => 62, # 70-74 years old
    '16' => 77, # 75-79 years old
    '17' => 82, # 80-84 years old
    '18' => 89 # 85 or more years old
  }
  METRO_MICRO = {
    'METRO' => 'Metro', # in a census metropolitan statistical area
    'MICRO' => 'Micro', # in a census micropolitan statistical area
    'NONE'  => nil
  }
  MICROWAVE_USE = {
    '1' => 'Most meals and snacks',
    '2' => 'About half of meals and snacks',
    '3' => 'A few meals and snacks',
    '4' => 'Very little'
  }
  MONTHLY_TIMES = {
    '0'  => 0,   # Not used
    '1'  => 100, # Three or more times a day
    '2'  => 61,  # Two times a day
    '3'  => 30,  # Once a day
    '4'  => 13,  # A few times a week
    '5'  => 4,   # About once a week
    '6'  => 2,   # Less than once a week
    '11' => 2,   # Less than once a week
    '12' => 4,   # Once a week
    '13' => 11,  # 2 or 3 times a week
    '20' => 22,  # 4 to 6 times a week
    '30' => 35,  # At least once each day
  }
  MONTHS_USE = {
    '1' => 2,  # 1 to 3 months
    '2' => 5,  # 4 to 6 months
    '3' => 8,  # 7 to 9 months
    '4' => 11, # 10 to 11 months
    '5' => 12  # All year
  }
  OWN_RENT = {
    '1' => 'Owner',
    '2' => 'Renter',
    '3' => nil
  }
  RACE = {
    '1' => 'White',
    '2' => 'Black / African American',
    '3' => 'American Indian or Alaska Native',
    '4' => 'Asian',
    '5' => 'Native Hawaiian or Pacific Islander',
    '6' => 'Other',
    '7' => 'Multiple'
  }
  RENEWABLE = {
    '1' => 'Grid-connected',
    '2' => 'Off-grid'
  }
  ROOF_MATERIAL = {
    '1' => 'Ceramic or Clay Tiles',
    '2' => 'Wood Shingles/Shakes',
    '3' => 'Metal',
    '4' => 'Slate or Synthetic Slate',
    '5' => 'Composition Shingles',
    '6' => 'Asphalt',
    '7' => 'Concrete Tiles',
    '8' => 'Other'
  }
  SEX = {
    '1' => 'Female',
    '2' => 'Male'
  }
  STORIES = {
    '10' => 1,
    '20' => 2,
    '31' => 3,
    '32' => 4,  # Four or more stories
    '40' => 2,  # Split-level
    '50' => nil # Other
  }
  TV_SIZE = {
    '1' => '20 inches or less',
    '2' => '21 to 26 inches',
    '3' => '37 inches or more'
  }
  TV_TYPE = {
    '1' => 'CRT',
    '2' => 'LCD',
    '3' => 'Plasma',
    '4' => 'Projection',
    '5' => 'LED'
  }
  TV_USE = {
    '1' => 1,
    '2' => 2,
    '3' => 5,
    '4' => 8,
    '5' => 12
  }
  URBAN_RURAL = {
    'U' => 'Urban',
    'R' => 'Rural'
  }
  VAMPIRES = {
    '1' => 'Chargers always unplugged',
    '2' => 'Chargers never unplugged',
    '3' => 'Chargers sometimes unplugged'
  }
  WALL_MATERIAL = {
    '1' => 'Brick',
    '2' => 'Wood',
    '3' => 'Siding (Aluminum, Vinyl, Steel)',
    '4' => 'Stucco',
    '5' => 'Composition (Shingle)',
    '6' => 'Stone',
    '7' => 'Concrete/Concrete Block',
    '8' => 'Glass',
    '9' => 'Other'
  }
  WASHER = {
    '1' => 'Top-loading',
    '2' => 'Front-loading'
  }
  WASHER_TEMP = {
    '1' => 'Hot',
    '2' => 'Warm',
    '3' => 'Cold'
  }
  WASHER_USE = {
    '1' => 3,  # 1 load or less each week
    '2' => 13, # 2 to 4 loads each week
    '3' => 30, # 5 to 9 loads each week
    '4' => 54, # 10 to 15 loads each week
    '5' => 70  # More than 15 loads each week
  }
  WATER_HEATER = {
    '1' => 'Storage',
    '2' => 'Tankless'
  }
  WATER_HEATER_SIZE = {
    '1' => 'Small (30 gallons or less)',
    '2' => 'Medium (31 to 49 gallons)',
    '3' => 'Large (50 gallons or more)'
  }
  WINDOW_PANES = {
    '1'  => 1,
    '2'  => 2,
    '3'  => 3
  }
  WINDOWS = {
    '0'  => 0,  # None
    '10' => 2,  # 1 or 2
    '20' => 4,  # 3 to 5
    '30' => 8,  # 6 to 9
    '41' => 13, # 10 to 15
    '42' => 18, # 16 to 19
    '50' => 25, # 20 to 29
    '60' => 35  # 30 or more
  }
  WINDOWS_REPLACED = {
    '1' => 'All',
    '2' => 'Some',
    '3' => 'None'
  }
  YEAR_INCENTIVIZED = {
    '1'  => 2006,
    '2'  => 2007,
    '3'  => 2008,
    '4'  => 2009,
    '5'  => 2003, # Prior to 2006
    '6'  => 2010
  }
  YEAR_OCCUPIED = {
    '1' => 1925, # Before 1950
    '2' => 1955, # 1950 to 1959
    '3' => 1965, # 1960 to 1969
    '4' => 1975, # 1970 to 1979
    '5' => 1985, # 1980 to 1989
    '6' => 1995, # 1990 to 1999
    '7' => 2002, # 2000 to 2004
    '8' => 2007  # 2005 to 2009
  }
  
  def computer_idle(on_off, sleep)
    if BOOLEAN[on_off]
      'Turned off'
    elsif BOOLEAN[sleep]
      'Sleep / standby'
    end
  end
  
  # Type of garage
  def garage(row)
    if BOOLEAN[row['PRKGPLC1']]
      'Attached'
    elsif BOOLEAN[row['PRKGPLC2']]
      'Detached'
    end
  end
  
  def heat_cool_coverage(any, all_some, portion)
    case any
    when '0' # no heating or cooling
      0
    when '1' # some heating or cooling
      case all_some
      when '1' # entire space heated or cooled
        1
      when '2' # part of space heated or cooled
        case portion
        when '1' # Very Little (1-4%)
          0.025
        when '2' # Some (5-33%)
          0.19
        when '3' # About Half (33-66%)
          0.5
        when '4' # About Three-Quarters (67-95%)
          0.75
        when '5' # Most of It (96-99%)
          0.975
        end
      end
    end
  end
  
  def numerize(value)
    number = value.to_i
    number < 0 ? nil : number
  end
  
  def oven_type(row)
    if BOOLEAN[row['OVENCLN']]
      case row['TYPECLN']
      when '1'
        'Continuous self-cleaning'
      when '2'
        'Manual self-cleaning'
      else
        "Not self-cleaning"
      end
    end
  end
  
  def payer(initial, follow_up)
    case initial
    when '1'
      'Paid by the household'
    when '2'
      'Included in rent'
    when '3'
      case follow_up
      when '1'
        'Paid by a relative'
      when '2'
        'Paid by rental or condo agency'
      when '3'
        'Paid by some other party'
      end
    end
  end
  
  def secondary_heating_systems(row)
    @secondary_heating_systems ||= {
      'Steam or Hot Water System'      => (row['RADFUEL']  if BOOLEAN[row['STEAMR'  ]]),
      'Central Warm-Air Furnace'       => (row['FURNFUEL'] if BOOLEAN[row['WARMAIR' ]]),
      'Heat Pump'                      => ('5'             if BOOLEAN[row['REVERSE' ]]),
      'Built-In Electric Units'        => ('5'             if BOOLEAN[row['PERMELEC']]),
      'Floor or Wall Pipeless Furnace' => (row['PIPEFUEL'] if BOOLEAN[row['PIPELESS']]),
      'Built-In Room Heaters'          => (row['RMHTFUEL'] if BOOLEAN[row['ROOMHEAT']]),
      'Heating Stove'                  => (row['HSFUEL']   if BOOLEAN[row['WOODKILN']]),
      'Fireplace'                      => (row['FPFUEL']   if BOOLEAN[row['CHIMNEY' ]]),
      'Portable Heaters'               => ('5'             if BOOLEAN[row['CARRYEL' ]]),
      'Portable Heaters'               => ('4'             if BOOLEAN[row['CARRYKER']]),
      'Cooking Stove'                  => (row['RNGFUEL']  if BOOLEAN[row['RANGE'   ]]),
      'Other'                          => (row['DIFFUEL']  if BOOLEAN[row['DIFEQUIP']])
    }.keep_if{|k,v| v}
  end
  
  def year_improved(improvement_age)
    2009 - improvement_age if improvement_age
  end
  
  def apply(row)
    parsed_row = {
      'area'                   => row['TOTSQFT'],
      'bathrooms'              => row['NCOMBATH'],
      'cdd_2009'               => row['CDD65'],
      'cdd_avg'                => row['CDD30YR'],
      'census_region_number'   => row['REGIONC'],
      'census_division_number' => row['DIVISION'],
      'climate_region_id'      => row['Climate_Region_Pub'],
      'climate_zone_id'        => row['AIA_Zone'],
      'computers'              => row['NUMPC'],
      'cooktops'               => row['STOVE'],
      'cool_area'              => row['TOTCSQFT'],
      'electricity'            => row['KWH'],
      'electricity_cost'       => row['DOLLAREL'],
      'energy'                 => row['TOTALBTU'],
      'energy_cost'            => row['TOTALDOL'],
      'fans'                   => row['NUMCFAN'],
      'fridges'                => row['NUMFRIG'],
      'fuel_oil'               => row['BTUFO'],
      'fuel_oil_cost'          => row['DOLLARFO'],
      'half_baths'             => row['NHAFBATH'],
      'hdd_2009'               => row['HDD65'],
      'hdd_avg'                => row['HDD30YR'],
      'heat_area'              => row['TOTHSQFT'],
      'household_size'         => row['NHSLDMEM'],
      'id'                     => row['DOEID'],
      'kerosene'               => row['BTUKER'],
      'kerosene_cost'          => row['DOLLARKER'],
      'lights_high_use'        => row['LGT12'],
      'lights_low_use'         => row['LGT1'],
      'lights_med_use'         => row['LGT4'],
      'member_1_age'           => row['HHAGE'],
      'other_rooms'            => row['OTHROOMS'],
      'natural_gas'            => row['BTUNG'],
      'natural_gas_cost'       => row['DOLLARNG'],
      'ovens'                  => row['OVEN'],
      'propane'                => row['BTULP'],
      'propane_cost'           => row['DOLLARLP'],
      'recs_grouping_id'       => row['REPORTABLE_DOMAIN'],
      'rooms'                  => row['TOTROOMS'],
      'sliding_doors'          => row['DOOR1SUM'],
      'stoves'                 => row['STOVEN'],
      'storage_water_heaters'  => row['NUMH2OHTRS'],
      'tankless_water_heaters' => row['NUMH2ONOTNK'],
      'tvs'                    => row['TVCOLOR'],
      'weighting'              => row['NWEIGHT'],
      'wood'                   => row['BTUWOOD'],
      'year_built'             => row['YEARMADE']
    }
    
    @secondary_heating_systems = nil
    (2..6).each do |i|
      parsed_row.merge!({
        "heater_#{i}"      => secondary_heating_systems(row).keys[i - 2],
        "heater_#{i}_fuel" => FUEL[secondary_heating_systems(row).values[i - 2]]
      })
    end
    
    parsed_row.merge!({
      'answering_machine'          => BOOLEAN[row['ANSMACH']],
      'aquarium'                   => BOOLEAN[row['AQUARIUM']],
      'apartments'                 => numerize(row['NUMAPTS']),
      'attic'                      => FINISHED_SPACE[row['ATTICFIN']],
      'attic_rooms'                => numerize(row['FINATTRMS']),
      'basement'                   => FINISHED_SPACE[row['BASEFIN']],
      'basement_rooms'             => numerize(row['FINBASERMS']),
      'bedrooms'                   => numerize(row['BEDROOMS']),
      'building_floors'            => [numerize(row['NUMFLRS']), STORIES[row['STORIES']]].compact.first,
      'building_type'              => BUILDING_TYPE[row['TYPEHUQ']],
      'caulking_added'             => BOOLEAN[row['INSTLWS']],
      'caulking_added_year'        => year_improved(AGE[row['AGEWS']]),
      'caulking_incent'            => INCENTIVE[row['HELPWS']],
      'caulking_incent_year'       => YEAR_INCENTIVIZED[row['HELPWSY']],
      'coffee'                     => BOOLEAN[row['COFFEE']],
      'computer_idle'              => computer_idle(row['PCONOFF1'], row['PCSLEEP1']),
      'computer_monitor'           => COMPUTER_MONITOR[row['MONITOR1']],
      'computer_type'              => COMPUTER_TYPE[row['PCTYPE1']],
      'computer_use'               => TV_USE[row['TIMEON1']],
      'computer_2_idle'            => computer_idle(row['PCONOFF2'], row['PCSLEEP2']),
      'computer_2_monitor'         => COMPUTER_MONITOR[row['MONITOR2']],
      'computer_2_type'            => COMPUTER_TYPE[row['PCTYPE2']],
      'computer_2_use'             => TV_USE[row['TIMEON2']],
      'computer_3_idle'            => computer_idle(row['PCONOFF3'], row['PCSLEEP3']),
      'computer_3_monitor'         => COMPUTER_MONITOR[row['MONITOR3']],
      'computer_3_type'            => COMPUTER_TYPE[row['PCTYPE3']],
      'computer_3_use'             => TV_USE[row['TIMEON3']],
      'condo_coop'                 => CONDO_COOP[row['CONDCOOP']],
      'converted_house'            => CONVERTED_HOUSE[row['LOOKLIKE']],
      'cooking_fuel'               => FUEL[row['FUELFOOD']],
      'cooking_frequency'          => MONTHLY_TIMES[row['NUMMEAL']],
      'cooktop_fuel'               => FUEL[row['STOVEFUEL']],
      'cool_attic_portion'         => heat_cool_coverage(row['ATTCCOOL'], row['ATTCCL2'], row['PCTATTCL']),
      'cool_auto_adjust_day'       => BOOLEAN[row['AUTOCOOLDAY']],
      'cool_auto_adjust_night'     => BOOLEAN[row['AUTOCOOLNITE']],
      'cool_basement_portion'      => heat_cool_coverage(row['BASECOOL'], row['BASECL2'], row['PCTBSTCL']),
      'cool_rooms'                 => numerize(row['ACROOMS']),
      'cool_temp_away'             => numerize(row['TEMPGONEAC']),
      'cool_temp_day'              => numerize(row['TEMPHOMEAC']),
      'cool_temp_night'            => numerize(row['TEMPNITEAC']),
      'cooler_ac_age'              => AGE[row['WWACAGE']],
      'cooler_ac_energy_star'      => BOOLEAN[row['ESWWAC']],
      'cooler_ac_incent'           => INCENTIVE[row['HELPWWAC']],
      'cooler_ac_incent_year'      => YEAR_INCENTIVIZED[row['HELPWWACY']],
      'cooler_ac_replaced'         => BOOLEAN[row['REPLCWWAC']],
      'cooler_ac_use'              => COOLER_USE[row['USEWWAC']],
      'cooler_acs'                 => numerize(row['NUMBERAC']),
      'cooler_central_age'         => AGE[row['AGECENAC']],
      'cooler_central_incent'      => INCENTIVE[row['HELPCAC']],
      'cooler_central_incent_year' => YEAR_INCENTIVIZED[row['HELPCACY']],
      'cooler_central_maintained'  => BOOLEAN[row['MAINTAC']],
      'cooler_central_replaced'    => BOOLEAN[row['REPLCCAC']],
      'cooler_central_shared'      => BOOLEAN[row['ACOTHERS']],
      'cooler_central_use'         => COOLER_USE[row['USECENAC']],
      'cooler_unused'              => COOLER[row['COOLTYPENOAC']],
      'copier'                     => BOOLEAN[row['COPIER']],
      'cordless_phone'             => BOOLEAN[row['NOCORD']],
      'crawlspace'                 => BOOLEAN[row['CRAWL']],
      'dehumidifier_use'           => MONTHS_USE[row['USENOTMOIST']],
      'dishwasher_age'             => AGE[row['AGEDW']],
      'dishwasher_energy_star'     => BOOLEAN[row['ESDISHW']],
      'dishwasher_use'             => MONTHLY_TIMES[row['DWASHUSE']],
      'dishwasher_incent'          => INCENTIVE[row['HELPDW']],
      'dishwasher_incent_year'     => YEAR_INCENTIVIZED[row['HELPDWY']],
      'dishwasher_replaced'        => BOOLEAN[row['REPLCDW']],
      'drafty'                     => DRAFTY[row['DRAFTY']],
      'dryer_age'                  => AGE[row['AGECDRYER']],
      'dryer_fuel'                 => FUEL[row['DRYRFUEL']],
      'dryer_use'                  => DRYER_USE[row['DRYRUSE']],
      'education'                  => EDUCATION[row['EDUCATION']],
      'electricity_heat'           => BOOLEAN[row['ELWARM']],
      'electricity_heat_2'         => BOOLEAN[row['ELECAUX']],
      'electricity_cool'           => BOOLEAN[row['ELCOOL']],
      'electricity_water'          => BOOLEAN[row['ELWATER']],
      'electricity_cooking'        => BOOLEAN[row['ELFOOD']],
      'electricity_other'          => BOOLEAN[row['ELOTHER']],
      'electronic_charging'        => CHARGING[row['ELECCHRG']],
      'electronic_vampires'        => VAMPIRES[row['CHRGPLGE']],
      'electronics'                => DEVICES[row['ELECDEV']],
      'employment'                 => EMPLOYMENT[row['EMPLOYHH']],
      'energy_audit'               => BOOLEAN[row['AUDIT']],
      'energy_audit_incent'        => INCENTIVE[row['HELPAUD']],
      'energy_audit_incent_year'   => YEAR_INCENTIVIZED[row['HELPAUDY']],
      'energy_audit_year'          => year_improved(AGE[row['AGEAUD']]),
      'engine_block_heater'        => BOOLEAN[row['DIPSTICK']],
      'fax'                        => BOOLEAN[row['FAX']],
      'fan_use'                    => COOLER_USE[row['USECFAN']],
      'food_stamps'                => BOOLEAN[row['FOODASST']],
      'freezers'                   => numerize(row['NUMFREEZ']),
      'freezer_age'                => AGE[row['AGEFRZR']],
      'freezer_defrost'            => DEFROST[row['FREEZER']],
      'freezer_incent'             => INCENTIVE[row['HELPFRZ']],
      'freezer_incent_year'        => YEAR_INCENTIVIZED[row['HELPFRZY']],
      'freezer_replaced'           => BOOLEAN[row['REPLCFRZ']],
      'freezer_size'               => FREEZER_SIZE[row['SIZFREEZ']],
      'freezer_type'               => FREEZER_TYPE[row['UPRTFRZR']],
      'freezer_2_age'              => AGE[row['AGEFRZR2']],
      'freezer_2_defrost'          => DEFROST[row['FREEZER2']],
      'freezer_2_size'             => FREEZER_SIZE[row['SIZFREEZ2']],
      'freezer_2_type'             => FREEZER_TYPE[row['UPRTFRZR2']],
      'fridge_age'                 => AGE[row['AGERFRI1']],
      'fridge_defrost'             => DEFROST[row['REFRIGT1']],
      'fridge_door_ice'            => BOOLEAN[row['ICE']],
      'fridge_energy_star'         => BOOLEAN[row['ESFRIG']],
      'fridge_size'                => FRIDGE_SIZE[row['SIZRFRI1']],
      'fridge_type'                => FRIDGE_TYPE[row['TYPERFR1']],
      'fridge_2_age'               => AGE[row['AGERFRI2']],
      'fridge_2_defrost'           => DEFROST[row['REFRIGT2']],
      'fridge_2_energy_star'       => BOOLEAN[row['ESFRIG2']],
      'fridge_2_size'              => FRIDGE_SIZE[row['SIZRFRI2']],
      'fridge_2_type'              => FRIDGE_TYPE[row['TYPERFR2']],
      'fridge_2_use'               => numerize(row['MONRFRI2']),
      'fridge_3_age'               => AGE[row['AGERFRI3']],
      'fridge_3_defrost'           => DEFROST[row['REFRIGT3']],
      'fridge_3_energy_star'       => BOOLEAN[row['ESFRIG3']],
      'fridge_3_size'              => FRIDGE_SIZE[row['SIZRFRI3']],
      'fridge_3_type'              => FRIDGE_TYPE[row['TYPERFR3']],
      'fridge_3_use'               => numerize(row['MONRFRI3']),
      'fridge_incent'              => INCENTIVE[row['HELPFRI']],
      'fridge_incent_year'         => YEAR_INCENTIVIZED[row['HELPFRIY']],
      'fridge_replaced'            => BOOLEAN[row['REPLCFRI']],
      'fuel_oil_heat'              => BOOLEAN[row['FOWARM']],
      'fuel_oil_heat_2'            => BOOLEAN[row['FOILAUX']],
      'fuel_oil_water'             => BOOLEAN[row['FOWATER']],
      'fuel_oil_other'             => BOOLEAN[row['FOOTHER']],
      'garage'                     => garage(row),
      'garage_cooled'              => BOOLEAN[row['GARGCOOL']],
      'garage_heated'              => BOOLEAN[row['GARGHEAT']],
      'garage_size'                => GARAGE_SIZE[(BOOLEAN[row['PRKGPLC1']] ? row['SIZEOFGARAGE'] : row['SIZEOFDETACH'])],
      'heat_attic_portion'         => heat_cool_coverage(row['ATTCHEAT'], row['ATTCHT2'], row['PCTATTHT']),
      'heat_auto_adjust_day'       => BOOLEAN[row['AUTOHEATDAY']],
      'heat_auto_adjust_night'     => BOOLEAN[row['AUTOHEATNITE']],
      'heat_basement_portion'      => heat_cool_coverage(row['BASEHEAT'], row['BASEHT2'], row['PCTBSTHT']),
      'heat_rooms'                 => numerize(row['HEATROOM']),
      'heat_temp_away'             => numerize(row['TEMPGONE']),
      'heat_temp_day'              => numerize(row['TEMPHOME']),
      'heat_temp_night'            => numerize(row['TEMPNITE']),
      'heater'                     => HEATER[row['EQUIPM']],
      'heater_age'                 => AGE[row['EQUIPAGE']],
      'heater_fuel'                => FUEL[row['FUELHEAT']],
      'heater_incent'              => INCENTIVE[row['HELPHT']],
      'heater_incent_year'         => YEAR_INCENTIVIZED[row['HELPHTY']],
      'heater_maintained'          => BOOLEAN[row['MAINTHT']],
      'heater_portion'             => HEATER_PORTION[row['EQMAMT']],
      'heater_replaced'            => BOOLEAN[row['REPLCHT']],
      'heater_shared'              => BOOLEAN[row['HEATOTH']],
      'heater_thermostats'         => numerize(row['NUMTHERM']),
      'heater_unused'              => HEATER[row['EQUIPNOHEAT']],
      'heater_unused_fuel'         => FUEL[row['FUELNOHEAT']],
      'high_ceiling'               => BOOLEAN[row['HIGHCEIL']],
      'home_business'              => BOOLEAN[row['HBUSNESS']],
      'home_during_week'           => BOOLEAN[row['ATHOME']],
      'hot_tub_fuel'               => FUEL[row['FUELTUB']],
      'humidifier_use'             => MONTHS_USE[row['USEMOISTURE']],
      'indoor_grill_fuel'          => FUEL[row['STGRILA']],
      'income'                     => INCOME[row['MONEYPY']],
      'income_employment'          => BOOLEAN[row['WORKPAY']],
      'income_retirement'          => BOOLEAN[row['RETIREPY']],
      'income_ssi'                 => BOOLEAN[row['SSINCOME']],
      'income_welfare'             => BOOLEAN[row['CASHBEN']],
      'income_investment'          => BOOLEAN[row['INVESTMT']],
      'income_other'               => BOOLEAN[row['RGLRPAY']],
      'insulation'                 => INSULATION[row['ADQINSUL']],
      'insulation_added'           => BOOLEAN[row['INSTLINS']],
      'insulation_added_year'      => year_improved(AGE[row['AGEINS']]),
      'insulation_incent'          => INCENTIVE[row['HELPINS']],
      'insulation_incent_year'     => YEAR_INCENTIVIZED[row['HELPINSY']],
      'internet'                   => BOOLEAN[row['INTERNET']],
      'kerosene_heat'              => BOOLEAN[row['KRWARM']],
      'kerosene_heat_2'            => BOOLEAN[row['KEROAUX']],
      'kerosene_water'             => BOOLEAN[row['KRWATER']],
      'kerosene_other'             => BOOLEAN[row['KROTHER']],
      'latino'                     => BOOLEAN[row['SDESCENT']],
      'levels'                     => [numerize(row['NAPTFLRS']), STORIES[row['STORIES']]].compact.first,
      'lights_high_use_efficient'  => numerize(row['LGT12EE']),
      'lights_incent'              => INCENTIVE[row['HELPCFL']],
      'lights_incent_year'         => YEAR_INCENTIVIZED[row['HELPCFLY']],
      'lights_low_use_efficient'   => numerize(row['LGT1EE']),
      'lights_med_use_efficient'   => numerize(row['LGT4EE']),
      'lights_outdoor'             => numerize(row['NOUTLGTNT']),
      'lights_outdoor_efficient'   => numerize(row['LGTOEE']),
      'lights_replaced'            => BOOLEAN[row['INSTLCFL']],
      'low_rent'                   => BOOLEAN[row['RENTHELP']],
      'member_2_age'               => MEMBER_AGE[row['AGEHHMEMCAT2']],
      'member_3_age'               => MEMBER_AGE[row['AGEHHMEMCAT3']],
      'member_4_age'               => MEMBER_AGE[row['AGEHHMEMCAT4']],
      'member_5_age'               => MEMBER_AGE[row['AGEHHMEMCAT5']],
      'member_6_age'               => MEMBER_AGE[row['AGEHHMEMCAT6']],
      'member_7_age'               => MEMBER_AGE[row['AGEHHMEMCAT7']],
      'member_8_age'               => MEMBER_AGE[row['AGEHHMEMCAT8']],
      'member_9_age'               => MEMBER_AGE[row['AGEHHMEMCAT9']],
      'member_10_age'              => MEMBER_AGE[row['AGEHHMEMCAT10']],
      'member_11_age'              => MEMBER_AGE[row['AGEHHMEMCAT11']],
      'member_12_age'              => MEMBER_AGE[row['AGEHHMEMCAT12']],
      'member_13_age'              => MEMBER_AGE[row['AGEHHMEMCAT13']],
      'member_14_age'              => MEMBER_AGE[row['AGEHHMEMCAT14']],
      'metro_micro'                => METRO_MICRO[row['METROMICRO']],
      'microwave_defrost'          => BOOLEAN[row['DEFROST']],
      'microwave_use'              => MICROWAVE_USE[row['AMTMICRO']],
      'natural_gas_heat'           => BOOLEAN[row['UGWARM']],
      'natural_gas_heat_2'         => BOOLEAN[row['UGASAUX']],
      'natural_gas_water'          => BOOLEAN[row['UGWATER']],
      'natural_gas_cooking'        => BOOLEAN[row['UGCOOK']],
      'natural_gas_other'          => BOOLEAN[row['UGOTH']],
      'other_heat'                 => BOOLEAN[row['OTHWARM']],
      'other_heat_2'               => BOOLEAN[row['OTHERAUX']],
      'other_water'                => BOOLEAN[row['OTHWATER']],
      'other_cooking'              => BOOLEAN[row['OTHCOOK']],
      'outdoor_grill_fuel'         => FUEL[row['OUTGRILLFUEL']],
      'oven_fuel'                  => FUEL[row['OVENFUEL']],
      'oven_type'                  => oven_type(row),
      'oven_use'                   => MONTHLY_TIMES[row['OVENUSE']],
      'own_rent'                   => OWN_RENT[row['KOWNRENT']],
      'pays_electricity_heat'      => payer(row['PELHEAT'], row['OTHERWAYEL']),
      'pays_electricity_water'     => payer(row['PELHOTWA'], row['OTHERWAYEL']),
      'pays_electricity_cooking'   => payer(row['PELCOOK'], row['OTHERWAYEL']),
      'pays_electricity_cool'      => payer(row['PELAC'], row['OTHERWAYEL']),
      'pays_electricity_lighting'  => payer(row['PELLIGHT'], row['OTHERWAYEL']),
      'pays_natural_gas_heat'      => payer(row['PGASHEAT'], row['OTHERWAYNG']),
      'pays_natural_gas_water'     => payer(row['PGASHTWA'], row['OTHERWAYNG']),
      'pays_natural_gas_cooking'   => payer(row['PUGCOOK'], row['OTHERWAYNG']),
      'pays_natural_gas_other'     => payer(row['PUGOTH'], row['OTHERWAYNG']),
      'pays_fuel_oil'              => payer(row['FOPAY'], row['OTHERWAYFO']),
      'pays_propane'               => payer(row['LPGPAY'], row['OTHERWAYLPG']),
      'pool_fuel'                  => FUEL[row['FUELPOOL']],
      'poverty_100'                => BOOLEAN[row['POVERTY100']],
      'poverty_150'                => BOOLEAN[row['POVERTY150']],
      'printers'                   => numerize(row['PCPRINT']),
      'propane_heat'               => BOOLEAN[row['LPWARM']],
      'propane_heat_2'             => BOOLEAN[row['LPGAUX']],
      'propane_water'              => BOOLEAN[row['LPWATER']],
      'propane_cooking'            => BOOLEAN[row['LPCOOK']],
      'propane_other'              => BOOLEAN[row['LPOTHER']],
      'public_housing_authority'   => BOOLEAN[row['HUPROJ']],
      'race'                       => RACE[row['Householder_Race']],
      'renewable_energy'           => RENEWABLE[row['ONSITEGRID']],
      'roof_material'              => ROOF_MATERIAL[row['ROOFTYPE']],
      'sex'                        => SEX[row['HHSEX']],
      'shaded'                     => BOOLEAN[row['TREESHAD']],
      'slab'                       => BOOLEAN[row['CONCRETE']],
      'solar_heat'                 => BOOLEAN[row['SOLWARM']],
      'solar_heat_2'               => BOOLEAN[row['SOLARAUX']],
      'solar_water'                => BOOLEAN[row['SOLWATER']],
      'solar_other'                => BOOLEAN[row['SOLOTHER']],
      'live_with_spouse'           => BOOLEAN[row['SPOUSE']],
      'stereo'                     => BOOLEAN[row['STEREO']],
      'stove_fuel'                 => FUEL[row['STOVENFUEL']],
      'telecommuting'              => numerize(row['TELLDAYS']),
      'toaster'                    => BOOLEAN[row['TOASTER']],
      'tool_charging'              => CHARGING[row['BATCHRG']],
      'tool_vampires'              => VAMPIRES[row['CHRGPLGT']],
      'tools'                      => DEVICES[row['BATTOOLS']],
      'tv_size'                    => TV_SIZE[row['TVSIZE1']],
      'tv_theater'                 => BOOLEAN[row['TVAUDIOSYS1']],
      'tv_type'                    => TV_TYPE[row['TVTYPE1']],
      'tv_weekday_use'             => TV_USE[row['TVONWD1']],
      'tv_weekend_use'             => TV_USE[row['TVONWE1']],
      'tv_2_size'                  => TV_SIZE[row['TVSIZE2']],
      'tv_2_theater'               => BOOLEAN[row['TVAUDIOSYS2']],
      'tv_2_type'                  => TV_TYPE[row['TVTYPE2']],
      'tv_2_weekday_use'           => TV_USE[row['TVONWD2']],
      'tv_2_weekend_use'           => TV_USE[row['TVONWE2']],
      'tv_3_size'                  => TV_SIZE[row['TVSIZE3']],
      'tv_3_theater'               => BOOLEAN[row['TVAUDIOSYS3']],
      'tv_3_type'                  => TV_TYPE[row['TVTYPE3']],
      'tv_3_weekday_use'           => TV_USE[row['TVONWD3']],
      'tv_3_weekend_use'           => TV_USE[row['TVONWE3']],
      'urban_rural'                => URBAN_RURAL[row['UR']],
      'unusual_activities'         => BOOLEAN[row['OTHWORK']],
      'wall_material'              => WALL_MATERIAL[row['WALLTYPE']],
      'washer'                     => WASHER[row['TOPFRONT']],
      'washer_age'                 => AGE[row['AGECWASH']],
      'washer_energy_star'         => BOOLEAN[row['ESCWASH']],
      'washer_incent'              => INCENTIVE[row['HELPCW']],
      'washer_incent_year'         => YEAR_INCENTIVIZED[row['HELPCWY']],
      'washer_replaced'            => BOOLEAN[row['REPLCCW']],
      'washer_temp_rinse'          => WASHER_TEMP[row['RNSETEMP']],
      'washer_temp_wash'           => WASHER_TEMP[row['WASHTEMP']],
      'washer_use'                 => WASHER_USE[row['WASHLOAD']],
      'water_heater'               => WATER_HEATER[row['H2OTYPE1']],
      'water_heater_age'           => AGE[row['WHEATAGE']],
      'water_heater_blanket'       => BOOLEAN[row['WHEATBKT']],
      'water_heater_fuel'          => FUEL[row['FUELH2O']],
      'water_heater_incent'        => INCENTIVE[row['HELPWH']],
      'water_heater_incent_year'   => YEAR_INCENTIVIZED[row['HELPWHY']],
      'water_heater_size'          => WATER_HEATER_SIZE[row['WHEATSIZ']],
      'water_heater_shared'        => BOOLEAN[row['WHEATOTH']],
      'water_heater_2'             => WATER_HEATER[row['H2OTYPE2']],
      'water_heater_2_age'         => AGE[row['WHEATAGE2']],
      'water_heater_2_fuel'        => FUEL[row['FUELH2O2']],
      'water_heater_2_size'        => WATER_HEATER_SIZE[row['WHEATSIZ2']],
      'well_pump'                  => BOOLEAN[row['WELLPUMP']],
      'window_panes'               => WINDOW_PANES[row['TYPEGLASS']],
      'windows'                    => WINDOWS[row['WINDOWS']],
      'windows_incent'             => INCENTIVE[row['HELPWIN']],
      'windows_incent_year'        => YEAR_INCENTIVIZED[row['HELPWINY']],
      'windows_replaced'           => WINDOWS_REPLACED[row['NEWGLASS']],
      'wood_heat'                  => BOOLEAN[row['WDWARM']],
      'wood_heat_2'                => BOOLEAN[row['WOODAUX']],
      'wood_water'                 => BOOLEAN[row['WDWATER']],
      'wood_other'                 => BOOLEAN[row['WDOTHUSE']],
      'year_occupied'              => YEAR_OCCUPIED[row['OCCUPYYRANGE']]
    })
  end
end
