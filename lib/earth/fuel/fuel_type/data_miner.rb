# DEPRECATED but FuelPurchase still uses this
FuelType.class_eval do
  # FIXME TODO phase 2
  # annual emissions factors
  # annual energy contents
  # gas-specific emissions factors
  
  data_miner do
    import "a list of fuels and their emission factors and densities",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdDR3RjlTcWlsLTc2TzQ0cERTMElJbHc&gid=0&output=csv' do
      key 'name', :field_name => 'fuel'
      store 'emission_factor', :units_field_name => 'emission_factor_units'
      store 'average_purchase_volume', :units_field_name => 'average_purchase_volume_units'
      store 'density', :units_field_name => 'density_units'
      # store 'energy_content', :field_name => 'energy_content', :units_field_name => 'energy_content_units', :to_units => 'FIXME' # FIXME need different conversions for different rows...
      # store 'carbon_content', :field_name => 'carbon_content', :units_field_name => 'carbon_content_units', :to_units => :kilograms_per_joule
    end
  end
end
