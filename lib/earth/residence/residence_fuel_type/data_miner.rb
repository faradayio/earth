ResidenceFuelType.class_eval do
  data_miner do
    schema Earth.database_options do
      string   'name'
      float    'emission_factor'
      string   'emission_factor_units'
      # float    'energy_content'
      # string   'energy_content_units'
    end
    
    import "a list of residential fuels and their emissions factors",
           :url => 'http://spreadsheets.google.com/pub?key=rukxnmuhhsOsrztTrUaFCXQ' do
      key 'name'
      store 'emission_factor', :field_name => 'emission_factor', :units_field_name => 'units'
    end
  end
end

