GreenhouseGas.class_eval do
  data_miner do
    import "greenhouse gas global warming potentials taken from the IPCC AR4",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdE1tUjBwS1ZHZnBUUG1XcVpkOTVHOVE&gid=0&output=csv' do
      key 'name'
      store 'abbreviation'
      store 'ipcc_report'
      store 'time_horizon', :units_field_name => 'time_horizon_units'
      store 'global_warming_potential'
    end
  end
end
