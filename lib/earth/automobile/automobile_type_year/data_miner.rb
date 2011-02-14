AutomobileTypeYear.class_eval do
  data_miner do
    schema Earth.database_options do
      string  'name'
      string  'type_name'
      integer 'year'
      float   'hfc_emissions'
      string  'hfc_emissions_units'
    end
    
    import "automobile type year air conditioning emissions derived from the 2010 EPA GHG Inventory",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdFoyTWhDeHpndTV5Ny1aX0sxR1ljSFE&hl=en&output=csv' do
      key   'name'
      store 'type_name'
      store 'year'
      store 'hfc_emissions', :units_field_name => 'hfc_emissions_units'
    end
    
    verify "Type name should never be missing" do
      AutomobileTypeYear.all.each do |record|
        value = record.send(:type_name)
        unless value.present?
          raise "Missing type name for AutomobileTypeYear '#{record.name}'"
        end
      end
    end
    
    verify "Year should be from 1990 to 2008" do
      AutomobileTypeYear.all.each do |record|
        year = record.send(:year)
        unless year > 1989 and year < 2009
          raise "Invalid year for AutomobileTypeYear '#{record.name}': #{year} (should be from 1990 to 2008)"
        end
      end
    end
    
    verify "HFC emissions should be zero or more" do
      AutomobileTypeYear.all.each do |record|
        emissions = record.send(:hfc_emissions)
        unless emissions >= 0
          raise "Invalid HFC emissions for AutomobileTypeYear '#{record.name}': #{emissions} (should be zero or more)"
        end
      end
    end
    
    verify "HFC emissions units should be kilograms CO2e" do
      AutomobileTypeYear.all.each do |record|
        units = record.send(:hfc_emissions_units)
        unless units == "kilograms_co2e"
          raise "Invalid HFC emissions units for AutomobileTypeYear '#{record.name}': #{units} (should be kilograms_co2e)"
        end
      end
    end
  end
end
