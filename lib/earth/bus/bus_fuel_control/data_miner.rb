BusFuelControl.class_eval do
  data_miner do
    import "a list of bus fuel controls",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEw1QW80VVJhaXRkUURQSFhHczNyVWc&gid=0&output=csv' do
      key   'name'
      store 'bus_fuel_name'
      store 'control'
      store 'ch4_emission_factor', :units_field_name => 'ch4_emission_factor_units'
      store 'n2o_emission_factor', :units_field_name => 'n2o_emission_factor_units'
    end
    
    process "Convert emission factors to metric units" do
      conversion_factor = (1 / 1.609344) * (1.0 / 1_000.0 ) # Google: 1 mile / 1.609344 km * 1 kg / 1000 g
      
      where(:ch4_emission_factor_units => 'grams_per_mile').update_all(%{
        ch4_emission_factor = 1.0 * ch4_emission_factor * #{conversion_factor},
        ch4_emission_factor_units = 'kilograms_per_kilometre'
      })
      where(:n2o_emission_factor_units => 'grams_per_mile').update_all(%{
        n2o_emission_factor = 1.0 * n2o_emission_factor * #{conversion_factor},
        n2o_emission_factor_units = 'kilograms_per_kilometre'
      })
    end
    
    # FIXME TODO verify this
  end
end
