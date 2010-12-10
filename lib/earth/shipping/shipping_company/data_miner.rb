ShippingCompany.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'corporate_emission_factor'
      string 'corporate_emission_factor_units'
    end
    
    import "a list of shipping companies and their characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdG1ONU1HZDdZTFJNclFYVkRzR0k5Z2c&hl=en&single=true&gid=0&output=csv' do
      key   'name'
      store 'corporate_emission_factor', :units_field_name => 'corporate_emission_factor_units'
    end
  end
end
