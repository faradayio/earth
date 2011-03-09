FuelCountryYear.class_eval do
  data_miner do
    schema Earth.database_options do
      string  'name'
      string  'fuel_country_name'
      string  'fuel_name'
      string  'country_iso_3166_code'
      integer 'year'
      string  'calorific_basis'
      float   'energy_content'
      string  'energy_content_units'
      float   'carbon_content'
      string  'carbon_content_units'
      float   'oxidation_factor'
      float   'biogenic_fraction'
      float   'co2_emission_factor'
      string  'co2_emission_factor_units'
      float   'co2_biogenic_emission_factor'
      string  'co2_biogenic_emission_factor_units'
    end
    
    import "US fuels with annually variable characteristics, derived from the 2010 EPA GHG Inventory",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdFM2bHI3WU5kN1N3RTFhdUR0VDRqMnc&gid=0&output=csv' do
      key 'name'
      store 'fuel_country_name'
      store 'fuel_name'
      store 'country_iso_3166_code'
      store 'year'
      store 'calorific_basis'
      store 'energy_content', :units_field_name => 'energy_content_units'
      store 'carbon_content', :units_field_name => 'carbon_content_units'
      store 'oxidation_factor'
      store 'biogenic_fraction'
    end
    
    process "Convert energy content of solid fuels to metric units" do
      conversion_factor = (1_055.05585 / 1.0) * (1.0 / 907.18474) # Google: 1_055.05585 MJ / 1 MMBtu * 1 short ton / 907.18474 kg
      connection.execute %{
        UPDATE fuel_country_years
        SET energy_content = energy_content * #{conversion_factor}, energy_content_units = 'megajoules_per_kilogram'
        WHERE energy_content_units = 'million_btu_per_short_ton'
      }
    end
    
    process "Convert energy content of liquid fuels to metric units" do
      conversion_factor = (1_055.05585 / 1.0) * (1.0 / 158.987295) # Google: 1_055.05585 MJ / 1 MMBtu * 1 barrel / 158.987295 l
      connection.execute %{
        UPDATE fuel_country_years
        SET energy_content = energy_content * #{conversion_factor}, energy_content_units = 'megajoules_per_litre'
        WHERE energy_content_units = 'million_btu_per_barrel'
      }
    end
    
    process "Convert energy content of gaseous fuels to metric units" do
      conversion_factor = (1.0 / 947.81712) * (35.3146667 / 1.0) # Google: 1.0 MJ / 947.81712 Btu * 35.3146667 cubic feet / 1 cubic m
      connection.execute %{
        UPDATE fuel_country_years
        SET energy_content = energy_content * #{conversion_factor}, energy_content_units = 'megajoules_per_cubic_metre'
        WHERE energy_content_units = 'btu_per_cubic_foot'
      }
    end
    
    process "Convert carbon content to metric units" do
      conversion_factor = (1_000_000_000_000.0 / 1.0) * (1.0 / 1_055_055_852_620.0) # Google: 1e12 g / Tg * 1 QBtu / 1.055e12 MJ
      connection.execute %{
        UPDATE fuel_country_years
        SET carbon_content = carbon_content * #{conversion_factor}, carbon_content_units = 'grams_per_megajoule'
        WHERE carbon_content_units = 'teragrams_per_quadrillion_btu'
      }
    end
    
    process "Calculate CO2 and CO2 biogenic emission factors" do
      conversion_factor = (1.0 / 1_000.0) * (44.0 / 12.0) # Google: 1 kg / 1e3 g * 44 CO2 / 12 C
      
      FuelCountryYear.all.each do |record|
        record.co2_emission_factor = record.carbon_content * record.energy_content * record.oxidation_factor * (1 - record.biogenic_fraction) * conversion_factor
        record.co2_emission_factor_units = "kilograms_per_" + record.energy_content_units.split("_per_")[1]
        
        record.co2_biogenic_emission_factor = record.carbon_content * record.energy_content * record.oxidation_factor * record.biogenic_fraction * conversion_factor
        record.co2_biogenic_emission_factor_units = "kilograms_per_" + record.energy_content_units.split("_per_")[1]
        
        record.save
      end
    end
    
    verify "Fuel country name should never be missing" do
      FuelCountryYear.all.each do |record|
        fuel_country_name = record.send(:fuel_country_name)
        if fuel_country_name.nil?
          raise "Missing fuel country name for FuelCountryYear '#{record.name}'"
        end
      end
    end
    
    # FIXME TODO verify fuel_name is in Fuel
    # FIXME TODO verify country_iso_3166_code is in Country
    
    verify "Year should be from 1990 to 2008" do
      FuelCountryYear.all.each do |record|
        year = record.send(:year)
        unless year > 1989 and year < 2009
          raise "Invalid year for FuelCountryYear '#{record.name}': #{year} (should be from 1990 to 2008)"
        end
      end
    end
    
    verify "Carbon content and energy content should be greater than zero" do
      FuelCountryYear.all.each do |record|
        %w{ carbon_content energy_content }.each do |attribute|
          value = record.send(:"#{attribute}")
          unless value > 0
            raise "Invalid #{attribute} for FuelCountryYear '#{record.name}': #{value} (should be > 0)"
          end
        end
      end
    end
    
    verify "Emission factors should be zero or more" do
      FuelCountryYear.all.each do |record|
        %w{ co2_emission_factor co2_biogenic_emission_factor }.each do |attribute|
          value = record.send(:"#{attribute}")
          unless value >= 0
            raise "Invalid #{attribute} for FuelCountryYear '#{record.name}': #{value} (should be >= 0)"
          end
        end
      end
    end
    
    # FIXME TODO verify units
  end
end
