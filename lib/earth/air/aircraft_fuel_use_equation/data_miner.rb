AircraftFuelUseEquation.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'aircraft_description'
      float  'm3'
      string 'm3_units'
      float  'm2'
      string 'm2_units'
      float  'm1'
      string 'm1_units'
      float  'b'
      string 'b_units'
    end
    
    import "aircraft fuel use equations derived from EMEP/EEA and ICAO",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdDltUVZVekVobEJPYlpFNUpWNkwyYXc&output=csv' do
      key 'aircraft_description', :synthesize => lambda { |row| row['aircraft_description'].downcase }
      store 'm3', :units_field_name => 'm3_units'
      store 'm2', :units_field_name => 'm2_units'
      store 'm1', :units_field_name => 'm1_units'
      store 'b',  :units_field_name => 'b_units'
    end
  end
end
