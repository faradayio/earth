AircraftFuelUseEquation.class_eval do
  data_miner do
    import "aircraft fuel use equations derived from EMEP/EEA and ICAO",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdDltUVZVekVobEJPYlpFNUpWNkwyYXc&output=csv' do
      key 'code'
      store 'aircraft_description'
      store 'm3', :units_field_name => 'm3_units'
      store 'm2', :units_field_name => 'm2_units'
      store 'm1', :units_field_name => 'm1_units'
      store 'b',  :units_field_name => 'b_units'
    end
  end
end
