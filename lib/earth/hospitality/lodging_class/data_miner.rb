LodgingClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'emission_factor'
      string 'emission_factor_units'
    end
    
    process "Define some unit conversions" do
      Conversions.register :pounds_co2e_per_room_night, :kilograms_co2e_per_room_night, 0.45359237
    end

    import "a list of rail classes and pre-calculated trip and fuel use characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGZZWmZtWEJlYzhRNXlPdWpBTldlcUE&hl=en&output=csv' do
      key   'name'
      store 'emission_factor', :from_units => :pounds_co2e_per_room_night, :to_units => :kilograms_co2e_per_room_night
    end
  end
end
