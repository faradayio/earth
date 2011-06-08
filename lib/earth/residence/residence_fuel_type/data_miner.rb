ResidenceFuelType.class_eval do
  data_miner do
    import "a list of residential fuels and their emissions factors",
           :url => 'http://spreadsheets.google.com/pub?key=rukxnmuhhsOsrztTrUaFCXQ&gid=0&output=csv' do
      key 'name'
      store 'emission_factor', :field_name => 'emission_factor', :units_field_name => 'units'
    end
  end
end

