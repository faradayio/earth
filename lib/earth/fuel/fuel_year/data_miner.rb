FuelYear.class_eval do
  data_miner do
    schema Earth.database_options do
      string  'name'
      string  'fuel_name'
      integer 'year'
      string  'fuel_common_name'
      float   'carbon_content'
      string  'carbon_content_units'
      float   'energy_content'
      string  'energy_content_units'
      float   'conversion_factor'
      float   'co2_emission_factor'
      string  'co2_emission_factor_units'
    end
    
    import "a list of fuel years and their carbon and energy contents, derived from the 2010 EPA GHG Inventory",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdFZVSlZ3SUZsTzZLVTB5bVk5THdBN2c&hl=en&single=true&gid=0&output=csv' do
      key 'name'
      store 'fuel_name'
      store 'year'
      store 'fuel_common_name'
      store 'carbon_content', :units_field_name => 'carbon_content_units'
      store 'energy_content', :units_field_name => 'energy_content_units'
    end
    
    process "Calculate CO2 emission factor" do
      conversion_factor = (1000000/1000000000000000)*(1000000000000/1000)*(1/158.987295)*(44/12)
      update_all "co2_emission_factor = carbon_content * energy_content * #{conversion_factor}"
      update_all "co2_emission_factor_units = kilograms_per_litre"
    end
    
    verify "Fuel name and fuel common name should never be missing" do
      FuelYear.all.each do |record|
        %w{ fuel_name fuel_common_name }.each do |attribute|
          value = record.send(:"#{attribute}")
          if value.nil?
            raise "Missing #{attribute} for FuelYear '#{record.name}'"
          end
        end
      end
    end
    
    verify "Year should be from 1990 to 2008" do
      FuelYear.all.each do |record|
        year = record.send(:year)
        unless year > 1989 and year < 2009
          raise "Invalid year for FuelYear '#{record.name}': #{year} (should be from 1990 to 2008)"
        end
      end
    end
    
    verify "Carbon content, energy content, and CO2 emission factor should be greater than zero" do
      FuelYear.all.each do |record|
        %w{ carbon_content energy_content co2_emission_factor }.each do |attribute|
          value = record.send(:"#{attribute}")
          unless value > 0
            raise "Invalid #{attribute} for FuelYear '#{record.name}': #{value} (should be > 0)"
          end
        end
      end
    end
    
    verify "Units should be correct" do
      FuelYear.all.each do |record|
        ["carbon_content_units teragrams_per_quadrillion_btu", "energy_content_units million_btu_per_barrel", "co2_emission_factor_units kilograms_per_litre"].each do |pair|
          attribute = pair.split[0]
          proper_units = pair.split[1]
          units = record.send(:"#{attribute}")
          unless units == proper_units
            raise "Invalid #{attribute} for FuelYear '#{record.name}': #{units} (should be #{proper_units})"
          end
        end
      end
    end
  end
end
