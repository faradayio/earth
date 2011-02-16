AutomobileFuel.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'code'
      string 'name'
      string 'base_fuel_name'
      string 'blend_fuel_name'
      float  'blend_portion' # the portion of the blend that is the blend fuel
      string 'distance_key' # used to look up annual distance from AutomobileTypeFuelYear
      string 'ef_key' # used to look up ch4 n2o and hfc emission factors from AutomobileTypeFuelYear
    end
    
    import "a list of pure automobile fuels",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdE9xTEdueFM2R0diNTgxUlk1QXFSb2c&output=csv' do
      key   'code'
      store 'name'
      store 'base_fuel_name'
      store 'distance_key'
      store 'ef_key'
    end
    
    import "a list of blended automobile fuels",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEswNGIxM0U4U0N1UUppdWw2ejJEX0E&output=csv' do
      key   'code'
      store 'name'
      store 'base_fuel_name'
      store 'blend_fuel_name'
      store 'blend_portion'
      store 'distance_key'
      store 'ef_key'
    end
    
    # FIXME TODO verify that base_fuel_name is always present + found in Fuel
    # FIXME TODO verify that blend_fuel_name is found in Fuel if present
    # FIXME TODO verify that blend_portion is 0 to 1 if present
    # FIXME TODO verify that distance_fuel_common_name is always present + found in AutomobileTypeFuelAge
    # FIXME TODO verify that ef_fuel_common_name is always present + found in AutomobileTypeFuelYear
  end
end
