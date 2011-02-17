AutomobileFuel.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      string 'code'
      string 'base_fuel_name'
      string 'blend_fuel_name'
      float  'blend_portion' # the portion of the blend that is the blend fuel
      string 'distance_key' # used to look up annual distance from AutomobileTypeFuelYear
      string 'ef_key' # used to look up ch4 n2o and hfc emission factors from AutomobileTypeFuelYear
    end
    
    import "a list of pure automobile fuels",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdE9xTEdueFM2R0diNTgxUlk1QXFSb2c&output=csv' do
      key   'name'
      store 'code'
      store 'base_fuel_name'
      store 'distance_key'
      store 'ef_key'
    end
    
    import "a list of blended automobile fuels",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEswNGIxM0U4U0N1UUppdWw2ejJEX0E&output=csv' do
      key   'name'
      store 'code'
      store 'base_fuel_name'
      store 'blend_fuel_name'
      store 'blend_portion'
      store 'distance_key'
      store 'ef_key'
    end
    
    # FIXME TODO verify code somehow
    
    %w{ base_fuel_name distance_key ef_key }.each do |attribute|
      verify "#{attribute.humanize} should never be missing" do
        AutomobileFuel.all.each do |fuel|
          value = fuel.send(:"#{attribute}")
          unless value.present?
            raise "Missing #{attribute.humanize.downcase} for AutomobileFuel #{fuel.name}"
          end
        end
      end
    end
    
    # FIXME TODO verify that base_fuel_name and blend_fuel_name are found in Fuel if present
    # FIXME TODO verify that distance_key is found in AutomobileTypeFuelYearAge
    # FIXME TODO verify that ef_key is found in AutomobileTypeFuelYear
    
    verify "Blend portion should be from 0 to 1 if present" do
      AutomobileFuel.all.each do |fuel|
        if fuel.blend_portion.present?
          unless fuel.blend_portion >=0 and fuel.blend_portion <= 1
            raise "Invalid blend portion for AutomobileFuel #{fuel.name}: #{fuel.blend_portion} (should be from 0 to 1)"
          end
        end
      end
    end
  end
end
